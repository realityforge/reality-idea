# reality-idea

[![Build Status](https://secure.travis-ci.org/realityforge/reality-idea.svg?branch=master)](http://travis-ci.org/realityforge/reality-idea)

An ruby model to represent and generate intellij idea project files.

## TODO

* Compiler configuration ala
```xml
<component name="CompilerConfiguration">
  <annotationProcessing>
    <profile default="true" enabled="true" name="Default">
      <sourceOutputDir name="generated/processors/main/java" />
      <sourceTestOutputDir name="generated/processors/test/java" />
      <outputRelativeToContentRoot value="true" />
    </profile>
  </annotationProcessing>
</component>
```
* Add CLI action that generates files from model.
* Add "integration" tests that given a model generates the files.
* Add hook to facets so they can determine if they generate.
  ie. facetManager will not generate if no facets.
  ie. remote repositories will not generate if no repositories.
* Add support for `WEB_MODULE`
* Add support for `NullableNotNullManager` component ala
```xml
<component name="NullableNotNullManager">
    <option name="myDefaultNullable" value="javax.annotation.Nullable" />
    <option name="myDefaultNotNull" value="javax.annotation.Nonnull" />
    <option name="myNullables">
      <value>
        <list size="6">
          <item class="java.lang.String" index="0" itemvalue="org.jetbrains.annotations.Nullable" />
          <item class="java.lang.String" index="1" itemvalue="javax.annotation.Nullable" />
          <item class="java.lang.String" index="2" itemvalue="javax.annotation.CheckForNull" />
          <item class="java.lang.String" index="3" itemvalue="org.springframework.lang.Nullable" />
          <item class="java.lang.String" index="4" itemvalue="edu.umd.cs.findbugs.annotations.Nullable" />
          <item class="java.lang.String" index="5" itemvalue="android.support.annotation.Nullable" />
        </list>
      </value>
    </option>
    <option name="myNotNulls">
      <value>
        <list size="4">
          <item class="java.lang.String" index="0" itemvalue="org.jetbrains.annotations.NotNull" />
          <item class="java.lang.String" index="1" itemvalue="javax.annotation.Nonnull" />
          <item class="java.lang.String" index="2" itemvalue="edu.umd.cs.findbugs.annotations.NonNull" />
          <item class="java.lang.String" index="3" itemvalue="android.support.annotation.NonNull" />
        </list>
      </value>
    </option>
  </component>
```  
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
* Configure node modules directory.
```xml
  <component name="NodeModulesDirectoryManager">
    <handled-path value="$PROJECT_DIR$/auth/client/node_modules" />
  </component>
```
* Typescript configuration?
```xml
  <component name="TypeScriptGeneratedFilesManager">
    <option name="version" value="1" />
  </component>
```
