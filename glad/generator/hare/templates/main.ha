{% set ctx_name = feature_set.name | capitalize %}
use types;

// Built-in loader
@symbol("eglGetProcAddress") fn eglGetProcAddress(procName: *const char) *void;

fn get_proc_address(proc_name: str) *void = {
	let cstr = ((&proc_name): *types::string).data: *const char;
	return eglGetProcAddress(cstr);
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
export fn load() void = {
	{% for command in feature_set.commands %}
	{{ command.name }} = get_proc_address("{{ command.name }}\0"): *fp_{{ command.name }};
	{% endfor %}
};

// Function loading with user loader
export type fp_get_proc_address = fn(procName: *const char) *void;

fn call_user_get_proc_address(user_get_proc_address: *fp_get_proc_address, proc_name: str) *void = {
	let cstr = ((&proc_name): *types::string).data: *const char;
	return user_get_proc_address(cstr);
};

export fn load_with_fn(user_get_proc_address: *fp_get_proc_address) void = {
	{% for command in feature_set.commands %}
	{{ command.name }} = call_user_get_proc_address(user_get_proc_address, "{{ command.name }}\0"): *fp_{{ command.name }};
	{% endfor %}
};
