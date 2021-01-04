
def encrypt(letter,c):
    """
    This function encrypts a letter via caesarcypher by shifting the alphabet over by c many characters
    it is assumed that only capital letters will be used.
    """
    out = ord(letter) + c
    if (out>90):
        out = 64+out-90
    return chr(out)

def devignette(encrypted,decrypted):
    pattern = []
    test = 1
    check = 1
    for i in range(0,len(encrypted)):
        diff = ord(decrypted[i]) - ord(encrypted[i])
        pattern.append(diff)
    print(pattern)
    while True:
        for j in range(0,len(encrypted)):
            if (j+test < len(encrypted)-1) and (pattern[j]==pattern[j+test]):
                check+=1
                if (check==((len(encrypted)-1)/test)):
                    return pattern[0:test]
        test+=1
    

"""
if you know the value of v:
    1)create an array of integers of length v. start all values as 0.
    2)each value in the array could potentially have a value from 1-26. 
    3)Run the message through a vignette cypher where the key is v
    4)use the given function to check if it is the decoded message
    5)If this returns false, increment the array of integers by one(once the row being incremented reaches 27 
        it becomes 0 and the row to the left of it is incremented by one)
    6)if all the possible values of the array of integers has been checked
    the worst case time complexity is O(26^v)


if you don't know the value of V:
    1) assume that v=1.
    2) repeat the steps of when the value of v is known
    3) if this returns FALSE, try v=v+1 and return to step 2
    4) if this doesnt work for every value of v from 1 to n where n is the length of the decrypted message,
         the decrypted message is not a possible solution
    The runtime complexity of this is O(n*26^v)
"""

if __name__ == "__main__":
    print(encrypt('Z',3))
    print(devignette("ABCDEFG","DFFHHJJ"))
