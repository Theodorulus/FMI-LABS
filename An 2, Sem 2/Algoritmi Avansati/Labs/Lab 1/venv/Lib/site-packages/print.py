def print_lol(the_list,indent=False,level=0):
	''' 我是注释 '''
	for each_item in the_list:
		if isinstance(each_item,list):
			print_lol(each_item,indent,level+1)
		else:	
			if(indent):
				print(level*1)
			print(each_item)
