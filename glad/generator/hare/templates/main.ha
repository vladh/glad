{% set ctx_name = feature_set.name | capitalize %}
use strings;

// Loader
@symbol("glXGetProcAddress") fn glXGetProcAddress(procName: *const u8) *void;

fn get_proc_address(name: str) *void = {
	let c_str = strings::to_c(name);
	defer { free(c_str); };
	return glXGetProcAddress(c_str: *const u8);
};

// Types
{% include 'types/' + spec.name + '.ha' ignore missing with context %}

// Constants
{% for enum in feature_set.enums %}
export def {{ enum.name|no_prefix }}: {{ enum|enum_type }} = {{ enum|enum_value }};
{% endfor %}

// Function pointers
{% for command in feature_set.commands %}
export type fp_{{ command.name }} = fn({{ command|params }}) {{ command.proto.ret|type }};
{% endfor %}

// Functions
{% for command in feature_set.commands %}
export let {{ command.name }}: *fp_{{ command.name }} = null: *fp_{{ command.name }};
{% endfor %}

// Function loading
export fn load() void = {
	{% for command in feature_set.commands %}
	{{ command.name }} = get_proc_address("{{ command.name }}"): *fp_{{ command.name }};
	{% endfor %}
};
