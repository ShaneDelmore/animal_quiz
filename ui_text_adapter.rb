class UITextAdapter
  def write(statement)
    puts statement
  end

  def read(question)
    write question
    gets.chomp
  end
end
