# reality-idea

[![Build Status](https://secure.travis-ci.org/realityforge/reality-idea.png?branch=master)](http://travis-ci.org/realityforge/reality-idea)

An ruby model to represent and generate intellij idea project files.

## TODO

* Add `artifacts` project component with artifacts such as: `exploded_ejb`, `exploded_ear`, `exploded_war`, `jar`
* Add `configurations` project component with configurations such as: `glassfish`, `remote_glassfish`, `default_testng`, `gwt`, `ruby_script`, `java`
* Add `datasources` project component.
* Add CLI action that generates files from model.
* Add "integration" tests that given a model generates the files.
* Add hook to facets so they can determine if they generate.
  ie. facetManager will not generate if no facets.
  ie. remote repositories will not generate if no repositories.
* Add support for `WEB_MODULE`
* Add `TsLint` profiler
```xml
  <component name="InspectionProjectProfileManager">
    <profile version="1.0">
      <option name="myName" value="Project Default" />
      <inspection_tool class="TsLint" enabled="true" level="ERROR" enabled_by_default="true" />
    </profile>
    <version value="1.0" />
  </component>
```
* Add additional properties for nodejs.
```xml
 <component name="PropertiesComponent">
    <property name="nodejs_interpreter_path" value="$USER_HOME$/.nodenv/shims/node" />
    <property name="node.js.path.for.package.tslint" value="project" />
    <property name="node.js.detected.package.tslint" value="true" />
    <property name="node.js.selected.package.tslint" value="" />
    <property name="node.js.path.for.package.stylelint" value="project" />
    <property name="node.js.detected.package.stylelint" value="true" />
    <property name="node.js.selected.package.stylelint" value="" />
    <property name="settings.editor.selected.configurable" value="Settings.Markdown.Preview" />
  </component>
```
