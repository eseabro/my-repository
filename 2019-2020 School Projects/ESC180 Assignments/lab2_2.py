def packet_size(packet):
    ''' 
    (int) --> (int)
    This function returns the number of items in the list.
    >>> packet_size([0,1,0,1])
    4
    '''
    return len(packet)

def error_indices(packet1, packet2):
    ''' 
    (int) --> (int)
    This function returns the indices of the differences between two lists.
    >>> error_indices([0,1,1,1], [1,1,0,1])
    [0, 2]
    >>> error_indices([1,1,0,1], [1,1,0,1])
    []
    '''
    error = []
    for x in range(0, len(packet1)):
        if packet1[x] != packet2[x]:
            error.append(x)
    return error

def packet_diff(packet1, packet2):
    ''' 
    (int) --> (int)
    This function returns the number of differences between the two lists.
    >>>packet_diff([0,1,0,1], [1,1,0,1])
    1
    >>> packet_diff([0,1,1,0], [0,1,1,0]) 
    0
    '''
    return len(error_indices(packet1, packet2))

if __name__ == "__main__":
    # test your bit error rate detector here
    print(packet_size([0, 1, 0, 1]))
    print(error_indices([1, 1, 0, 1], [1, 1, 0, 1]))
    print(packet_diff([0, 1, 1, 0], [0, 1, 1, 0]))