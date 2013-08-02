class Animal
  attr_reader :species

  def initialize(species)
    @species = species.to_sym
  end

  def name
    species.to_s
  end

  def ==(other_animal)
    species == other_animal.species
  end
end
