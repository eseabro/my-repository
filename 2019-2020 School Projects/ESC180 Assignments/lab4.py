#import utilities.py 
BAD_CHARS =  ['"', "(", ")", "{", "}", "[", "]", "_"]
VALID_PUNCTUATION = ['?', '.' , '!', ',', ':', ';']
def parse_text(text):
    new_text = text
    for i in BAD_CHARS:
        new_text = new_text.replace(i , " ")
    
    for punctuation in VALID_PUNCTUATION:
        new_text = new_text.replace(punctuation, " "+punctuation+" ")
        
    new_text = new_text.lower()
    return new_text.split()

        
def parse_story(file_name):
    text = open(file_name, "r")
    x = parse_text(text.read())
    text.close()
    return x

def get_prob_from_count(counts):
    total = sum(counts)
    new_counts = []
    for item in counts:
        n_item = item/total
        new_counts.append(n_item)
    return new_counts

def build_ngram_counts(words, n):
    ngrams = []
    for i in range(len(words)-n):
        grams = words[i:i+n]
        ngrams.append(tuple(grams))
    next_words = words[n:]
    z = []
    print(ngrams)
    words = ' '.join(words)
    dick = {}
    for i in range(len(ngrams)): 
        total = []
        total = list(ngrams[i])
        total.append(next_words[i])
        total = ' '.join(total)
        z.append(words.count(str(total)))
        if ngrams[i] in dick:
            if next_words[i] not in (dick.get(ngrams[i]))[0]:
                l = dick.get(ngrams[i])
                l[0].append(next_words[i])
                l[1].append(z[i])
        else:
            dick[ngrams[i]] = [[next_words[i]], [z[i]]]
    return dick

def prune_ngram_counts(counts, prune_len):
    for num in counts:
        temp = prune_len
        numbers = counts.get(num)
        numbers_us = [int(x) for x in numbers[1]]
        numbers_us.sort()
        if len(numbers_us) > prune_len:
            if numbers_us[len(numbers_us)-temp-1] == numbers_us[len(numbers_us)-temp]:
                temp += 1
            for x in numbers_us[0:len(numbers_us)-temp]:
                i = numbers[1].index(x)
                del numbers[0][i]
                del numbers[1][i]
            counts[num] = numbers
    return counts

def probify_ngram_counts(counts):
    for num in counts:
        values = counts.get(num)
        numbers = values[1]
        idk = get_prob_from_count(numbers)
        values[1] = idk
        counts[num] = values 
    return counts

#def build_ngram_model(words, n):
    #model = build_ngram_counts(words, n)
    #for nums in words:
        
    #model = prune_ngram_counts(ordered, 15)
    #return probify_ngram_counts(model)

def gen_bot_list(ngram_model, seed, num_tokens):
    N = len(seed)
    sentence = []
    if num_tokens == 0:
        return sentence
    if N > num_tokens:
        sentence = seed[0: num_tokens+1]
        return sentence 
    for i in range(num_tokens):
        if seed not in ngram_model:
            sentence= list(seed)
            return sentence
        if ngram_model[seed] == []:
            return sentence
        sentence.append(gen_next_token(seed, ngram_model))
        seed = sentence[i:N+1]
        
def gen_bot_text(token_list, bad_author):
    sentence = ""
    if bad_author == 1:
        for i in token_list:
            sentence = sentence + i + " "
    else: 
        for i in token_list:
            if token_list.index(i) == 0:
                sentence = i.capitalize()
            elif i in VALID_PUNCTUATION:
                sentence = sentence + i 
            elif token_list[(token_list.index(i)-1)] in END_OF_SENTENCE_PUNCTUATION:
                sentence = sentence + " " + i.capitalize()
            elif i in ALWAYS_CAPITALIZE:
                sentence = sentence + " " + i.capitalize()
            else: 
                sentence = sentence + " " + i.lower()
    return sentence

    
        
    
if __name__ == "__main__":
    #print(parse_story("test_text.txt"))
    #print(get_prob_from_count([10, 20, 40, 30]))
    print(build_ngram_counts(['the', 'child', 'will', 'go', 'out', 'to', 'play', ',', 'and', 'the', 'child', 'can', 'not', 'be', 'sad', 'anymore', '.'], 3))
    ngram_counts = {('i', 'love'): [['js', 'py3', 'c', 'no'], [20, 20, 10, 2]],('u', 'r'): [['cool', 'nice', 'lit', 'kind'], [8, 7, 5, 5]],('toronto', 'is'): [['six', 'drake'], [2, 3]]}
    #print(prune_ngram_counts(ngram_counts, 3))
    #words = s = ['the', 'child', 'will', 'the', 'child', 'can', 'the', 'child', 'will', 'the', 'child', 'may','go', 'home', '.']
    #print(probify_ngram_counts(ngram_counts))
    #print(build_ngram_model(words, 2))
    #ngram_model = {('the', 'child'): [['will', 'can','may'], [0.5, 0.25, 0.25]], ('child', 'will'): [['the'], [1.0]], ('will', 'the'): [['child'], [1.0]], ('child', 'can'): [['the'], [1.0]], ('can', 'the'): [['child'], [1.0]], ('child', 'may'): [['go'], [1.0]], ('may', 'go'): [['home'], [1.0]], ('go', 'home'): [['.'], [1.0]] }
    #print(gen_bot_list(ngram_model, ('the', 'child'), 5))
    #token_list = ['this', 'is', 'a', 'string', 'of', 'text', '.', 'which', 'needs', 'to', 'be', 'created', '.']
    #print(gen_bot_text(token_list, True))