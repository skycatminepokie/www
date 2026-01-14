---
title: Dev Fixes
authors:
  - skycatminepokie
---

# Dev Fixes

This is a collection of a bunch of random problems and fixes for Fabric developers.

[TOC]

## Fabric API mixins aren't applying

```text
Mixin apply for mod fabric-registry-sync-v0 failed...
InvalidMixinException @Shadow method method_63535 in fabric-registry-sync-v0.mixins.json:SimpleRegistryMixin 
from mod fabric-registry-sync-v0 was not located in the target class...
```

Fixes:

1. Check that you're using the right version of Fabric API for your Minecraft version.
2. Try [regenerating run configs](#run-configurations-are-broken)
3. Try making your dependencies non-transitive. Using the Kotlin Gradle DSL:

```kt
modImplementation("me.lucko:fabric-permissions-api:${property("deps.permissions_api")}") {
    isTransitive = false
}
```

## Run configurations are broken

To regenerate them:

1. Delete `.idea/runConfigurations`
2. Reload the Gradle project
3. Reload `.idea` from disk (or restart IntelliJ)

## `registration of listener on 'Gradle.addListener' is unsupported`

It's not your fault! See [fabric-loom#1349](https://github.com/FabricMC/fabric-loom/issues/1349). To fix it, add this to your `gradle.properties`:

```properties
org.gradle.configuration-cache=false
```

(yes, that's it)

## `IllegalClassLoadError: good.testmod.mixin.TestModClient is in a defined mixin package...`

Non-mixin classes (like `TestModClient` presumably is) can't be in your mixin package.
