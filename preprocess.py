# Imports
import string
from os import listdir
from nltk import sent_tokenize
from os.path import isfile, join

# Opening file and reading text
text = ""
path = "./input_data/"
files = [f for f in listdir(path) if isfile(join(path, f))]
for filename in files:
    f = open(join(path, filename))
    text += f.read()
    f.close()

# Splitting words
raw_words = text.split()
words = set()
for word in raw_words:
    new_word = []
    for c in word:
        if c not in string.punctuation and c != "\"":
            new_word.append(c)
    new_word = ''.join(new_word)
    if new_word not in words:
        words.add(new_word)
words = sorted(words)

# Splitting sentences
raw_sentences = set(sent_tokenize(text))

# Processing sentences
sentences = set()
for raw_sent in raw_sentences:
    sentences.add(' '.join(sorted(set(raw_sent.split()))))

# Exporting words
f = open('preprocessed_data/words.txt', 'w')
for word in words:
    f.write(word)
    f.write('\n')
f.close()

# Exporting sentences
f = open('preprocessed_data/sents.txt', 'w')
for sent in sentences:
    f.write(sent)
    f.write('\n')
f.close()