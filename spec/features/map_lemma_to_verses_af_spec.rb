RSpec.describe "Map Lemma to AF Verse", type: :feature do

  it "Creates a map of Words to AF Verses" do
    first_word_occurrence_map = {}
    File.open("./private_data/af/af-word-verse-mapping.csv") do |file|
      puts "file opened"
      file.each do |line|
        next if line.strip.empty?
        reference, leader, word, trailer, lemma, part_of_speech = line.strip.split(",")

        if first_word_occurrence_map[lemma].nil?
          first_word_occurrence_map[lemma] = {
            reference: reference,
            part_of_speech: part_of_speech,
            unmarked_lemma: remove_markings(lemma)
          }
        end
      end
      puts "work done"
    end

    af_text_map = {}
    File.open("./private_data/af/af-verses.tsv") do |file|
      puts "file opened"
      file.each do |line|
        next if line.strip.empty?
        reference, verse = line.strip.split("\t")

        if af_text_map[reference].nil?
          af_text_map[reference] = verse
        end
      end
      puts "work done"
    end

    tabbed_data = []
    first_word_occurrence_map.each do |lemma, data|
      reference = data[:reference]
      part_of_speech = data[:part_of_speech]
      unmarked_lemma = data[:unmarked_lemma]
      verse_text = af_text_map[reference]

      first_word_occurrence_map[lemma][:verse_text] = verse_text

      tabbed_data.push("#{lemma}\t#{unmarked_lemma}\t#{reference}\t#{verse_text}\t#{part_of_speech}")
    end

    File.write('af-lemma-example-verses.json', JSON.dump(first_word_occurrence_map))
    File.write('af-lemma-example-verses.tsv', tabbed_data.join("\n"))
    puts "finished"
  end

  it "Removes all markings from Greek Characters" do
    word_list = []
    File.open("./private_data/af/af-words-accented.txt") do |file|
      puts "file opened"
      file.each do |line|
        next if line.strip.empty?
        word = line.strip
        unmarked_word = remove_markings(word)

        word_list.push(unmarked_word)
      end
      puts "work done"
    end

    File.write('af-words-unmarked.txt', word_list.join("\n"))
  end

end