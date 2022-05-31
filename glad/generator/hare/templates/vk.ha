use types;

// Built-in loader
@symbol("vkGetInstanceProcAddr") fn _vkGetInstanceProcAddr(instance: nullable *void, procName: *const char) *void;
@symbol("vkGetDeviceProcAddr") fn _vkGetDeviceProcAddr(device: nullable *void, procName: *const char) *void;

fn get_instance_proc_address(instance: nullable *void, proc_name: *const char) *void = {
	let cstr = ((proc_name): *types::string).data: *const char;
	return _vkGetInstanceProcAddr(instance, cstr);
};
fn get_device_proc_address(device: nullable *void, proc_name: *const char) *void = {
	let cstr = ((proc_name): *types::string).data: *const char;
	return _vkGetDeviceProcAddr(device, cstr);
};

// Types
{% include 'types/' + spec.name + '.ha' ignore missing with context %}

// Constants
{% for enum in feature_set.enums %}
export def {{ enum.name }}: {{ enum|enum_type }} = {{ enum|enum_value }};
{% endfor %}

// Function pointers
{% for command in feature_set.commands %}
export type fp_{{ command.name }} = fn({{ command|params }}) {{ command.proto.ret|type }};
{% endfor %}

// Functions
{% for command in feature_set.commands %}
export let {{ command.name }}: *fp_{{ command.name }} =
	null: *fp_{{ command.name }};
{% endfor %}

// Function loading with built-in loader
export fn load_loader() void = {
	{% for command in feature_set.commands %}
	{% if not (command.params[0].type|is_descendant("VkInstance")) %}
	{{ command.name }} = get_instance_proc_address(null, "{{ command.name }}\0"): *fp_{{ command.name }};
	{% endif %}
	{% endfor %}
};

export fn load_instance(instance: VkInstance) void = {
	{% for command in feature_set.commands %}
	{% if command.params[0].type|is_descendant("VkInstance", ["VkDevice"]) %}
	{{ command.name }} = get_instance_proc_address(instance, "{{ command.name }}\0"): *fp_{{ command.name }};
	{% endif %}
	{% endfor %}
};

export fn load_device(device: VkDevice) void = {
	{% for command in feature_set.commands %}
	{% if command.params[0].type|is_descendant("VkDevice") %}
	{{ command.name }} = get_device_proc_address(device, "{{ command.name }}\0"): *fp_{{ command.name }};
	{% endif %}
	{% endfor %}
};
