# Imports
import re
import string
from os import listdir
from nltk import sent_tokenize
from xml.etree import cElementTree as ET
from os.path import isfile, join, splitext

# Splitting words
def SplitWords (text):
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
    return words

# Splitting sentences
def SplitSentences (text):
    raw_sentences = set(sent_tokenize(text))
    sentences = set()
    for raw_sent in raw_sentences:
        sentences.add(' '.join(sorted(set(raw_sent.split()))))
    return sentences

# Exporting words
def AppendWords (words):
    f = open('preprocessed_data/words.txt', 'w')
    for word in words:
        f.write(word)
        f.write('\n')
    f.close()
    pass

# Exporting sentences
def AppendSents (sentences):
    f = open('preprocessed_data/sents.txt', 'w')
    for sent in sentences:
        f.write(sent)
        f.write('\n')
    f.close()
    pass

# Deleting all preprocessed data
f = open('preprocessed_data/words.txt', 'w')
f.write('')
f.close()
f = open('preprocessed_data/sents.txt', 'w')
f.write('')
f.close()
# Opening input files and preprocessing data
path = "./input_data/"
files = [f for f in listdir(path) if isfile(join(path, f))]
for filename in files:
    print("== Processing file {}".format(filename))
    text = ""
    ext = splitext(filename)[1]
    f = open(join(path, filename))
    if (ext == ".txt"):
        text += f.read()
    elif (ext == ".xml"):
        xml_str = f.read()
        text += re.sub(r'<.+?>', '', xml_str)
    f.close()
    AppendWords(SplitWords(text))
    AppendSents(SplitSentences(text))