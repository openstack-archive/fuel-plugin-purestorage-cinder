# Custom function to generate a random hex string of length arg[0].
#
# This is used to ensure we get unique tenant and user IDs that
# are required for the glance image-cache for cinder

module Puppet::Parser::Functions
  newfunction(:get_random_id, :type => :rvalue, :doc => "returns a random hex string of length args[0]") do |args|
    raise(Puppet::ParseError, "get_random_id(): Wrong number of arguments " +
      "given (#{args.size} for 1)") if args.size != 1
    numbers  = (0..9).to_a
    alpha = ('a'..'z').to_a
    length = args[0].to_i
    CHARS = (alpha + numbers)
    id = CHARS.sort_by { rand }.join[0...length]
    return id
  end
end
