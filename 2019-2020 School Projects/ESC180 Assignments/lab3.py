import utilities

def rotate_90_degrees(image_array, direction):
    #1 for clock_wise. -1 for anticlockwise
    m = len(image_array) 
    n = len(image_array[0]) 
    output_array = []    
    if direction == 1: #clockwise
        for j in range(n):
            row = [] #clears row every time so that it doesn't duplicate rows
            for i in reversed(range(m)):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row) 
    
    if direction == -1: #counterclockwise
        for j in reversed(range(n)):
            row = [] #clears row every time so that it doesn't duplicate rows
            for i in range(m):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row) 
                       
    return output_array
    
def flip_image(image_array, axis):
   # axis = -1 (along x = y), 0 along y, 1 along x

    m = len(image_array) 
    n = len(image_array[0]) 
    output_array = []    
    if axis == 0:
        for i in range(m):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in reversed(range(n)):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row) 
        return output_array
    if axis == 1:
        for i in reversed(range(m)):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in range(n):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row) 
        
    if axis == -1:
        for i in reversed(range(m)):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in reversed(range(n)):
                row.append(image_array[j][i]) #appends the values from image array into row
            output_array.append(row)         
        

    return output_array

def invert_grayscale(image_array):
    m = len(image_array) 
    n = len(image_array[0]) 
    output_array = []
    for i in range(m):
        row = [] #clears row every time so that it doesn't duplicate rows
        for j in range(n):
            row.append(255- image_array[i][j]) #appends the values from image array into row
        output_array.append(row)   
        
    return output_array

def crop(image_array, direction, n_pixels):
    m = len(image_array) 
    n = len(image_array[0])     
    output_array = []
    if direction == 'left':
        for i in range(m):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in range(n_pixels, n):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row) 
         
    if direction == 'right':
        for i in range(m):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in range(n-n_pixels):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row)     
    if direction == 'up':
        for i in range(n_pixels, m):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in range(n):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row)     
    if direction == 'down':
        for i in range(m-n_pixels):
            row = [] #clears row every time so that it doesn't duplicate rows
            for j in range(n):
                row.append(image_array[i][j]) #appends the values from image array into row
            output_array.append(row)         
    return output_array

def rgb_to_grayscale(rgb_image_array):
    m = len(rgb_image_array) 
    n = len(rgb_image_array[0])     
    output_array = []
    
    for i in range(m):
        row = [] #clears row every time so that it doesn't duplicate rows
        for j in range(n):
            r = rgb_image_array[i][j][0]
            g = rgb_image_array[i][j][1]
            b = rgb_image_array[i][j][2]
            k = (0.2989*r)+(0.5870*g)+(0.1140*b)
            row.append(rgb_image_array[i][j]) #appends the values from image array into row
            row[j] = k
        output_array.append(row) 

    return output_array

def invert_rgb(image_array):
    m = len(image_array) 
    n = len(image_array[0]) 
    output_array = []
    for i in range(m):
        row = [] #clears row every time so that it doesn't duplicate rows
        for j in range(n):
            r = image_array[i][j][0]
            g = image_array[i][j][1]
            b = image_array[i][j][2]
            r=255-r
            g=255-g
            b=255-b
            
            row.append(image_array[i][j]) #appends the values from image array into row
            row[j] = [r,g,b]
        
        output_array.append(row)    
    return output_array
    


if (__name__ == "__main__"):
    #file = 'robot.png'
    #utilities.write_image(rgb_to_grayscale(
    #    utilities.image_to_list(file)), 'gray.png')
    print("rotate: ",rotate_90_degrees([[1, 2, 3],[4, 5, 6],[7, 8, 9]], -1))
    print("flip: ", flip_image([[1, 2, 3],[4, 5, 6],[7, 8, 9]], -1))
    