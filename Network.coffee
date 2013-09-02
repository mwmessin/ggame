class @Network
	constructor: ({@nodes, @edges}) -> null
	
	depth: (s) -> null
	
	breadth: (s) -> null
	
	minSpan: -> #kruskal
		results = []
		for edge in @edges.sort((a, b) -> a[2] - b[2])
			source = @nodes[edge[0]]
			target = @nodes[edge[1]]
			if !source.visited or !target.visited
				source.visited = target.visited = true
				results.push(edge)
		results
	
	shortest: (s) -> #djikstra
		#for node in @nodes
			
	
	maxflow: (s, t) -> #ford-fulkerson

@n = new Net
	nodes: [
		{name: "a"}
		{name: "b"}
		{name: "c"}
		{name: "d"}
	]
	edges: [
		[0, 1, 1.13]
		[1, 2, 1.14]
		[2, 3, 1.13]
		[3, 0, 1.6]
	]	

$ -> console.log(n.minSpan())
	