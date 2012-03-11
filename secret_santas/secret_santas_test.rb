load "secret_santa.rb"
require "test/unit"

class TestSecretSanta < Test::Unit::TestCase
  def setup
    @persons = [["Luke", "Skywalker", "<luke@theforce.net>"],
     ["Leia", "Skywalker", "<leia@therebellion.org>"],
     ["Toula", "Portokalos", "<toula@manhunter.org>"],
     ["Gus", "Portokalos", "<gus@weareallfruit.net>"],
     ["Bruce", "Wayne", "<bruce@imbatman.com>"],
     ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"],
     ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"]]
    @instance = SecretSanta.new(@persons, false)
  end

  def test_person_is_not_their_own_santa
    person = @persons.sample
    options = @instance.santa_options_for_person(person)

    assert !options.include?(person)
  end

  def test_santa_is_not_in_own_family
    person = @persons.sample
    options = @instance.remove_family_members(person, @persons)
    options.delete person

    family_persons = @persons.collect{|x| x if x[1] != person[1]}.compact

    pp options[0].size
    puts family_persons.size
    assert options.size == family_persons.size, "Sizes aren't the same"

    assert options == family_persons
  end
end
