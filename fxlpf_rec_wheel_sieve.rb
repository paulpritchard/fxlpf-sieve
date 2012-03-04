##
# Method primes_up_to(limit,primes) is a prime-number sieve:
#   primes_up_to(N,p) stores all primes <= N, in order, in the given empty array p
# The running-time is proportional to N/loglogN.
#
# It is based on one of several algorithms presented in:
#   Paul Pritchard,
#   Linear Prime-Number Sieves: A Family Tree".
#   Science of Computer Programming 9(1): 17-35 (1987)
#
# The algorithm computes least-prime-factor(n) for non-primes n, 2 <= n <= N.
# It does so with a pair of nested loops, the outer one over the cofactors f,
# and the inner one over the primes p, where n = p*f and p = least-prime-factor(n).
# A wheel is used to avoid processing most non-primes. See
#   Paul Pritchard,
#   "Explaining the Wheel Sieve".
#   Acta Informatica 17: 477-485 (1982)
# (Thanks to my man Jonathan Sorenson for pointing out the obvious!)
#
# NB This is a recursive version to highlight the simplicity of the algorithm.
#    The implementation is written for maximum clarity, not speed.
#
class Wheel
# The Wheel with index i (i >= 0) is the residue class of the products of the first i primes,
# i.e., the repeating pattern of numbers not divisible by any of the first i primes
#
# def index; @index end
  def primes; @primes end
  def circ; @circ end # circumference
  def vals; @vals end
  def pr; @pr end # the first member of the extended wheel after 1; this is a prime
  def initialize; @primes = []; @circ = 1; @vals = [1]; @pr = 2 end #W_0, representing 1,2,3,4,...
  def upto(max) # iterator up to N (rolling the wheel)
    i = 0; base = 0
    loop do
      n = base+@vals[i]
      if n > max; break else yield n end
      if !@vals[i += 1]; i = 0; base += @circ end
    end
  end
  def next! # updates to the next wheel
    @primes << @pr
    @vals = 0.upto(@pr-1).collect{|i| @vals.map{|n| i*@circ+n}}.flatten(1) - @vals.map{|n| @pr*n} # +
    # +We could also use the iterator here
    @circ *= @pr
    @pr = @vals[1] || @circ+@vals[0]
  # @index += 1
  end
end

def primes_up_to (limit, primes)
  primes_up_to(Math.sqrt(limit),primes) unless limit < 2
  # get wheel
  w = Wheel.new
  while w.pr*w.circ <= limit; w.next! end
  # remove wheel primes
  while primes[0] && primes[0] < w.pr; primes.shift end
  # sieve, taking co-factors f from wheel
  lpf = []
  w.upto(limit/w.pr){|f| f > 1 && primes.take_while{|p| p*f <= limit && p <= (lpf[f] || f)}.each{|p| lpf[p*f] = p}}
  # gather primes, only checking values on extended wheel
  primes.clear
  primes.concat(w.primes)
  w.upto(limit){|n| n > 1 && !lpf[n] && primes << n}
end
