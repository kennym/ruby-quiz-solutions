# Secret Santas
# Sample format of a name list:
# Luke Skywalker   <luke@theforce.net>
# Leia Skywalker   <leia@therebellion.org>
# Toula Portokalos <toula@manhunter.org>
# Gus Portokalos   <gus@weareallfruit.net>
# Bruce Wayne      <bruce@imbatman.com>
# Virgil Brigman   <virgil@rigworkersunion.org>
# Lindsey Brigman  <lindsey@iseealiens.net>

# Your script should then choose a Secret Santa for every name in the list. Obviously, a person cannot be their own
# Secret Santa. In addition, my friends no longer allow people in the same family to be Santas for each other and your
# script should take this into account.

# Output is obvious. E-mail the Santa and tell them who their person is.

require 'pp'
class Array
  def random
    shuffle.first
  end
end

class SecretSanta
  def initialize(person_list, parse_list)
    if parse_list
      @persons = parse_person_list(person_list)
    else
      @persons = person_list
    end

    @persons_with_santas = persons_with_secret_santas
  end

  def parse_person_list(person_list)
    persons = []

    person_list.each do |person|
      person = person.scan(/^(\w*)\s(\w*)\s*(\S*)/)
      persons.push person
    end
    return persons
  end

  def remove_family_members(person, persons)
    [persons].collect{ |i| i if i[1] != person[1] }.compact
  end

  def santa_options_for_person(person)
    persons = @persons.dup
    persons.delete person

    pp persons
    persons = remove_family_members(person, persons)

    return persons[0]
  end

  def pick_santa_from_options(options)
    santa = options.random
    return santa[0]
  end

  def persons_with_secret_santas
    persons_with_secret_santas = []
    @persons.each do |person|
      options = santa_options_for_person(person)
      santa = pick_santa_from_options(options)
      persons_with_secret_santas.push([].push(person[0], santa[0]))
    end
    return persons_with_secret_santas
  end

  def announce_person_with_santa
     @persons_with_santas.each do |person, santa|
       puts "The santa of #{person[0] + " " + person[1]} is #{santa[0] + " " + santa[1]}"
     end
  end
end

def main
  list = []
  name_list_file = "name_list" if ARGV[0].nil?
  begin
    file = File.new(name_list_file, "r")
    while (line = file.gets)
      list.push line
    end
    file.close
  rescue Exception => e
    puts "Exception: #{e}"
    e
  end

  secret_santa = SecretSanta.new(list, true)
  secret_santa.announce_person_with_santa
end

main()