define([
	'gui'
], function(
	GUI
) {

function TabsGroup(input) {
	this.id = input.id;
	this.type = input.type;

	if (this.type == null) {
		this.type = 'pill';
	}
}

TabsGroup.prototype.add = function(input) {
	input.tabbar = this.id;
	input.type = this.type;

	return GUI.addTab(input);
}

return {
	TabsGroup: TabsGroup
}

});
