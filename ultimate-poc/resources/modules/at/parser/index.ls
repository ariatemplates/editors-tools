require! {
	_: lodash

	'pegjs-parser/parser'
	htmlParser: '../../html/parser'
}



class Parser extends parser.Parser
	~> super require './grammar'

	/**
	 * @fixme The node should be replaced, for now it can just be altered in place.
	 */
	post-process: (graph) ->
		graph.traverse (node) -> if node.type.element is 'block'
			htmlNodes = _.filter node.children, (.type.element is null)
			htmlValue = [child.properties.value for child in htmlNodes] * ''
			node.add 'html' htmlParser.parse htmlValue
		graph



module.exports = Parser!
