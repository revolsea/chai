# TODO: variations (linux only, by architecture), uses_from_macos

[.[] | {
  package_name: .name,
  build_deps: .build_dependencies,
  runtime_deps: .dependencies,
  recommended_deps: .recommended_dependencies,
  test_deps: .test_dependencies,
  optional_deps: .optional_dependencies
} | 
  # here's where we'd substitute the depends_on_type ids, for each depends_on type ids
  # the `[]` at the end is to ensure that we're exploding the arrays, so each dependency gets its own row!
    {package_name: .package_name, depends_on_type: $build_deps_type_id, depends_on: .build_deps[]},
    {package_name: .package_name, depends_on_type: $runtime_deps_type_id, depends_on: .runtime_deps[]},
    {package_name: .package_name, depends_on_type: $recommended_deps_type_id, depends_on: .recommended_deps[]},
    {package_name: .package_name, depends_on_type: $test_deps_type_id, depends_on: .test_deps[]},
    {package_name: .package_name, depends_on_type: $optional_deps_type_id, depends_on: .optional_deps[]}
  |
  # now, filter out the null dependencies
  select(.depends_on != null) |
  # and only look at the ones that are strings (some objects are present)
  select(.depends_on | type == "string") | 
  # generate the sql statements!
  "INSERT INTO dependencies (version_id, dependency_id, dependency_type_id) VALUES (
    (SELECT id FROM versions WHERE import_id = '" + .package_name + "' ORDER BY created_at DESC LIMIT 1),
    (SELECT id FROM packages WHERE import_id = '" + .depends_on + "'),
    '" + .depends_on_type + "') ON CONFLICT DO NOTHING;"
] | join("\n")