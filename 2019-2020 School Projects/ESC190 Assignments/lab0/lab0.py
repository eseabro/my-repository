from lab0_utilities import *
	
class Languages:
	def __init__(self):
		self.data_by_year = {}

	def build_trees_from_file(self, file_object):
		contents = (list(file_object))
		tree_cont = []
		lang = []
		nodes = []
		#print(contents)
		for i in contents:
			i = i.replace('\n','')
			tree_cont.append(list(i.split(',')))
		tree_cont = tree_cont[1:len(tree_cont)+1]
		for a in tree_cont:
			a[0] = int(a[0])
			a[2] = int(a[2])
		#print(tree_cont)
		for x in tree_cont:
			if x[0] not in self.data_by_year:
				self.data_by_year[x[0]] = BalancingTree(Node(LanguageStat(x[1], x[0], x[2])))
				
			else:
				self.data_by_year[x[0]].balanced_insert(Node(LanguageStat(x[1],x[0],x[2])))
		#print(self.data_by_year[1931].to_print(self.data_by_year[1931].root))
		return self.data_by_year
		




	def query_by_name(self, language_name):
		newdic = {}
		for items in self.data_by_year:
			tr = self.data_by_year.get(items)
			node = tr.looking_for_node(language_name)
			newdic[node.val.year] = node.val.count
		return newdic

	def query_by_count(self, threshold = 0):
		newdic = {}
		print(self.data_by_year)
		for items in self.data_by_year:
			tr = self.data_by_year.get(items)
			#print('val is')
			#print(tr)
			#print(tr.tree_trav())
			listy = tr.tree_trav()
			#print(listy)
			langs = []
			for no in listy:
				if no.val.count > threshold:
					langs.append(no.val.name)
			newdic[no.val.year] = langs			

		return newdic




class BalancingTree:
	def __init__(self, root_node):
		self.root = root_node
	
	def balanced_insert(self, node, curr = None):
		curr = curr if curr else self.root
		self.insert(node, curr)
		#self.to_print(self.root)
		self.balance_tree(node)
		#self.to_print(self.root)


	def insert(self, node, curr = None):
		curr = curr if curr else self.root
		# insert at correct location in BST
		if node._val < curr._val:
			if curr.left is not None:
				self.insert(node, curr.left)
			else:
				node.parent = curr
				curr.left = node
		else:
			if curr.right is not None:
				self.insert(node, curr.right)
			else:
				node.parent = curr
				curr.right = node
		return


	def balance_tree(self, node):
		self.repair(self.root)
		#root is updated
		while not self.is_balanced():
			#while tree isn't balanced --> does a check every iteration
			for fix in self.bad:
				while True:
					if fix.bf == 2:
						if abs(fix.right.bf) == 2:
							fix = fix.right
						else:
							break
					else:
						if abs(fix.left.bf) == 2:
							fix = fix.left
						else:
							break
					
				if fix.bf == 2:
					if fix.right.bf == 1:
						self.left_rotate(fix)
					else:						
					
						self.right_rotate(fix.right)
						
						self.left_rotate(fix) 
				else:
					if fix.left.bf == -1:
						self.right_rotate(fix)
					else:
						self.left_rotate(fix.left)
						self.right_rotate(fix)
				
				self.repair(self.root)
		
 

	def update_height(self, node):
		node.height = 1 + max(self.height(node.left), self.height(node.right))


	def height(self, node):
		return node.height if node else -1


	def left_rotate(self, z):
		y = z.right
		y.parent = z.parent
		if y.parent is None:
			self.root = y
		else:
			if y.parent.left is z:
				y.parent.left = y
			elif y.parent.right is z:
				y.parent.right = y
		z.right = y.left
		if z.right is not None:
			z.right.parent = z
		y.left = z
		z.parent = y
		self.update_height(z)
		self.update_height(y)


	def right_rotate(self, z):
		y = z.left
		y.parent = z.parent
		if y.parent is None:
			self.root = y
		else:
			if y.parent.right is z:
				y.parent.right = y
			elif y.parent.left is z:
				y.parent.left = y
		z.left = y.right
		if z.left is not None:
			z.left.parent = z
		y.right = z
		z.parent = y
		self.update_height(z)
		self.update_height(y)

	def find_balance_factor(self, c_node):
		if c_node.right!= None and c_node.left != None:
			diff = c_node.right.height - c_node.left.height
			return diff
		elif c_node.right != None:
			r = 1 + c_node.right.height
			return r
		elif c_node.left != None:
			l = -1 - c_node.left.height
			return l
		else:
			return 0


	def is_balanced(self):
		#checking to see if the tree is balanced
		self.bad = []
		self.lis_wrongbfs(self.root)
		return self.bad == []

	
	def looking_for_node(self, look4nod):

		curr_nod = self.root
		while True:
			if look4nod < curr_nod.val.name:
				curr_nod = curr_nod.left
			if look4nod > curr_nod.val.name:
				curr_nod = curr_nod.right
			if look4nod == curr_nod.val.name:
				return curr_nod
			if look4nod != curr_nod.val.name and curr_nod.right == None and curr_nod.left == None:
				return None
			
	def tree_trav(self, cur=1):
		trav_lis = []
		if cur == 1:
			cur = self.root
		if cur:
			trav_lis = self.tree_trav(cur.left)
			trav_lis.append(cur)
			trav_lis = trav_lis + self.tree_trav(cur.right)
		return trav_lis
			
		
		
	def repair(self, c_node):
		'''
		this function provides an updated version of all node arguments
		'''
		if c_node:
			c_node.height=self.hot(c_node)
			self.repair(c_node.right)
			self.repair(c_node.left)
			c_node.bf = self.find_balance_factor(c_node)
			
	def hot(self, c_node):
		if c_node:
			return 1 + max(self.hot(c_node.left), self.hot(c_node.right))
		else:
			return -1
		
	def lis_wrongbfs(self, c_node):
		if c_node:
			if abs(c_node.bf) >= 2:
				self.bad.append(c_node)
			else:
				self.lis_wrongbfs(c_node.right)
				self.lis_wrongbfs(c_node.left)
	def to_print(self, node):
		if node:
			x = node.left._val if node.left else 'None'
			y = node.right._val if node.right else 'None'
			z = node.parent._val if node.parent else 'None'
			print('Node {}, parent = {}, left = {}, right = {}, balance_factor {}'.format(node._val, z, y, x, node.bf))
			print('Node Height', node.height)
			self.to_print(node.left)
			self.to_print(node.right)

			
			
	
