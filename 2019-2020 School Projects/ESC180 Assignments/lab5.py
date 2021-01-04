import time
class Node:
    def __init__(self, data, left = None, right = None):
        self.value = data
        self.left = left
        self.right = right
        
    def __str__(self):
        return str(self.value)
    
class BinarySearchTree:
    def __init__(self, root = None):
        self.root = root
        
    def insert(self, node):
               
        if self.root == None:
            self.root = Node(node)
            
        else:
            #insert into tree
            #make a loop to see where it fits in the list
            pil = self.root
            while True:
                if str(node) in str(pil):
                    break
                if str(node) <  str(pil):
                    if pil.left == None:
                        pil.left = Node(node)
                        break
                    else:
                        pil = pil.left
                        
                elif str(node) > str(pil):
                    if pil.right == None:
                        pil.right = Node(node)
                        break
                    else:
                        pil = pil.right
                        
                        
                
    def search(self, value):
        start_t = time.time()
        if value == self.root.value:
            total_t = time.time() - start_t
            print(total_t)             
            return True
        else:
            curr_val = self.root
            while True:
                if value < str(curr_val.value):
                    curr_val = curr_val.left
                if value > str(curr_val.value):
                    #start searching right branch
                    curr_val = curr_val.right
                if value  == str(curr_val.value):
                    total_t = time.time() - start_t
                    print(total_t)
                    return True 
                if curr_val.left == None and curr_val.right == None:
                    total_t = time.time() - start_t
                    print(total_t)                    
                    return False
        
                
    
def constructBST(filename):
    file = open(filename, 'r')
    tree = BinarySearchTree()
    for line in file.readlines():
        tree.insert(line)
    file.close()
    return tree

    
if __name__ == "__main__":
    fname = "websites.txt"
    print("--- Constructing BST ---")
    construct_flag = True
    try:
        bst = constructBST(fname)
        print("No syntax or runtime errors occured in constructBST.")
        print("Root: " + str(bst.root))
    except:
        print("Could not construct BST.")
        construct_flag = False

    if construct_flag:
        print("--- Basic Traversal Check ---")
        print("Leftmost traversal: ")
        curr_Node = bst.root
        while curr_Node != None:
            curr_Node = curr_Node.left
            print(curr_Node)

        print("Rightmost traversal: ")
        curr_Node = bst.root
        while curr_Node != None:
            curr_Node = curr_Node.right
            print(curr_Node)

        print("Basic traversal check complete.")

    print("Tester complete.")    
    print(BinarySearchTree.search(bst, 'warf.or' + '\n'))