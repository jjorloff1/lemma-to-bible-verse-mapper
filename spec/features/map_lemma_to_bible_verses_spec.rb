RSpec.describe "Map Lemma to Bible Verse", type: :feature do
  # "Can load the page" is just a test to make sure the framework is working
  it "Can load the book verse file" do
    # puts File.basename(Dir.getwd)
    File.open("./private_data/SBLGNTtxt/61-Mt.txt") do |file|
      file.each do |line|
        puts line
      end
    end
  end
  it "Can load the book morphology file" do

    File.open("./private_data/SBLGNTmorph/61-Mt-morphgnt.txt") do |file|
      file.each do |line|
        components = line.split(' ')
        book = components[0][0..1]
        chapter = components[0][2..3]
        verse = components[0][4..6]
        lemma = components[6]
        puts "#{book} #{chapter}:#{verse} #{lemma}"
      end
    end
  end
end