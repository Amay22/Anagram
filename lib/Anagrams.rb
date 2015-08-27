# Finds Anagrams of all files in the Dictionary
class Anagrams
  attr_accessor :word, :nodes, :used, :all

  def initialize
    @word = false
    @nodes = {}
  end

  def load_dictionary(word_file_name = File.dirname(__FILE__) + '/words.txt')
    words = File.read(word_file_name).split("\n").map(&:downcase)
    words.each { |word| self.<< word.chomp }
  end

  def <<(word)
    node = word.each_char.inject(self) { |nod, char| nod.nodes[char] ||= Anagrams.new }
    node.word = true
  end

  def find(letters)
    @all = []
    @used = frequency_map(letters)
    recursive_find self, ''
    all.delete(letters)
    puts letters + ':' + "#{@all}" if all.length >= 1
    @all
  end

  def recursive_find(root, word)
    nodes.reject { |c| root.used[c] == 0 }.each do |char, node|
      root.used[char] -= 1
      node.recursive_find(root, word + char)
      root.used[char] += 1
    end
    root.all << word if self.word
  end

  def frequency_map(letters)
    letters.each_char.inject(Hash.new(0)) { |map, char| (map[char] += 1) && map }
  end
end

solver = Anagrams.new
solver.load_dictionary.each do |word|
  solver.find(word).sort { |x, y| x.length <=> y.length }
end
