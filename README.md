# lemma-to-bible-verse-mapper

In this project I have a couple RSPEC tests that will read in Greek Bible Data and ultimately produce a file that provides a sample verse for every greek lemma in the New Testament.

## How to use
Note: If you are only interested in the data, I have committed the output files to this repo.  They are:
* bible.json: a JSON map of the SBLGNT where Book, Chapter, and Verse are the keys.
* lemma-example-verses.json: a JSON map of Greek Lemmas to the first Bible verse they appear in.
* lemma-example-verses.tsv: a tab delimited list containing Lemma, Reference, and Verse

### Instructions to Run Script
1. Download SBLGNT Morphology Data from [the biblicalhumanities/sblgnt repo](https://github.com/biblicalhumanities/sblgnt). Extract those file into `private_data/SBLGNTmorph` at the root of this project.
2. Download the [SBLGNT Text and Apparatus](https://sblgnt.com/download/SBLGNTtxt.zip) from the [SBLGNT Downloads Page](https://sblgnt.com/download/).  Extract those files into `private_data/SBLGNTtxt`
3. Run `bundle install` at the root of this project (I am assuming you already have ruby and a bundler installed)
4. Run `1. Create bible.json` from the `map_lemma_to_bible_verses_spec`
5. Run `2. Create Lemma Example Files` from the `map_lemma_to_bible_verses_spec`

## Licensing
The SBLGNT text itself is subject to the SBLGNT EULA and the morphological parsing and lemmatization is made available under a CC-BY-SA License from https://github.com/biblicalhumanities/sblgnt

The data committed to this repo and produced by these scripts can be freely used and distributed in accordance with the [SBLGNT License](https://www.sblgnt.com/license/)
The source code committed to this repo is made available under a [CC-BY-SA License](https://creativecommons.org/licenses/by-sa/4.0/).  You are free to distribute, but please attribute me.