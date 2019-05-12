# SBT

From Wikipedia: 'sbt is an open-source build tool for Scala and Java projects, similar to Java's Maven and Ant.' 

It provides an automated process to generate JAR files without having to manually track down dependencies & associated JAR files required by a Scala project. 

## Usage

Provided in this directory is a sample hello world SBT project structure for compiling Scala files into JAR files. This example is based off - 
SBT Hello World (https://docs.scala-lang.org/getting-started-sbt-track/getting-started-with-scala-and-sbt-on-the-command-line.html)

### Folder Structure
The folder structure is like below -
```

build.sbt
|--lib (Un-Managed Dependancies)
|--project (Project config)
|--src
|   |-main
|   |   |-scala (stores main Scala source files)
|--target (Compiled files)
```
### Un-Managed Dependancies (Lib Folder)
You can add specific JAR files manually that need to be included for your project to this folder. This is separate and in addition to the automated process utilised in the build.sbt file.

### Managed Dependancies
The build.sbt file is where you can add the specific library dependencies for your project without the need to track down the associated JAR files utilising your favourite text editor. Dependencies are in the format 

- groupId, artifactId, and revision.

For example:
```
libraryDependencies += "org.apache.spark" %% "spark-core" % "1.5.0"
```
Indicates the Apache Spark library, the spark core & version 1.5.0. Note that by using '%%' instead of '%' after the `org.apache.spark` reference, it will automatically include the scala version. E.g.

```
libraryDependencies += "org.apache.spark" %% "spark-core" % "1.5.0"
```
is equivalent to
```
libraryDependencies += "org.apache.spark" % "spark-core_2.11" % "1.5.0"
```
where the Scala version is 2.11. See this [documentation](https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html) for further details on how to construct the dependencies.

### Building the Project

To compile / run  or build the jar, change to the root of the 015_sbt_hello-world-template directory (where the build.sbt file is located)  then use these commands.

* To compile the project:
```
sbt compile
```
* To run the project, type
```
sbt run
```

* To package the project (produce a jar file)
```
sbt package
```

The JAR file will be created under the target folder, within a Scala folder matching the Scala version. 

For example

```
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template# sbt package
[info] Loading settings for project root-015_sbt_hello-world-template-build from assembly.sbt ...
[info] Loading project definition from /home/big_data_tutorials/tutorials/015_sbt_hello-world-template/project
[info] Updating ProjectRef(uri("file:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/project/"), "root-015_sbt_hello-world-template-build")...
[info] Done updating.
[warn] There may be incompatibilities among your library dependencies; run 'evicted' to see detailed eviction warnings.
[info] Loading settings for project root-015_sbt_hello-world-template from build.sbt ...
[info] Set current project to hello-world (in build file:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/)
[info] Updating ...
[info] Done updating.
[success] Total time: 1 s, completed May 11, 2019 5:51:38 AM
```
And then to run our new JAR file:
```
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template# cd target
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/target# cd scala-2.12/
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/target/scala-2.12# scala hello-world_2.12-1.0.jar
Hello, World!
```


### SBT Assembly

While the above will build a JAR file, you still need to use Scala to run it. You can also build a 'Fat' JAR file, which will include the Scala framework in the JAR file, so that you can run it with standard Java. The SBT Assembly functionality is enabled by the `assembly.sbt` file in the project directory. You can find further information for SBT Assembly [here](https://github.com/sbt/sbt-assembly). An example on how to produce an SBT Assembly file is below:


```
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template# sbt assembly
[info] Loading settings for project root-015_sbt_hello-world-template-build from assembly.sbt ...
[info] Loading project definition from /home/big_data_tutorials/tutorials/015_sbt_hello-world-template/project
[info] Updating ProjectRef(uri("file:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/project/"), "root-015_sbt_hello-world-template-build")...
[info] Done updating.
[warn] There may be incompatibilities among your library dependencies; run 'evicted' to see detailed eviction warnings.
[info] Loading settings for project root-015_sbt_hello-world-template from build.sbt ...
[info] Set current project to hello-world (in build file:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/)
[info] Updating ...
[info] Done updating.
[info] Strategy 'discard' was applied to a file (Run the task at debug level to see details)
[info] Assembly up to date: /home/big_data_tutorials/tutorials/015_sbt_hello-world-template/target/scala-2.12/hello-world-assembly-1.0.jar
[success] Total time: 2 s, completed May 11, 2019 5:56:47 AM
```
And then to run the JAR file with Java:
```
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template# cd target
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/target# cd scala-2.12/
root@:/home/big_data_tutorials/tutorials/015_sbt_hello-world-template/target/scala-2.12# java -jar hello-world-assembly-1.0.jar
Hello, World!
```






