---
title: Dev Fixes
authors:
  - skycatminepokie
---

# Dev Fixes

This is a collection of a bunch of random problems and fixes for Fabric developers.

## Fabric API mixins aren't applying

```text
Mixin apply for mod fabric-registry-sync-v0 failed...
InvalidMixinException @Shadow method method_63535 in fabric-registry-sync-v0.mixins.json:SimpleRegistryMixin 
from mod fabric-registry-sync-v0 was not located in the target class...
```

Fixes:

1. Check that you're using the right version of Fabric API for your Minecraft version.
2. Try [regenerating run configs](#run-configurations-broken)
3. Try making your dependencies non-transitive. Using the Kotlin Gradle DSL:

```kt
modImplementation("me.lucko:fabric-permissions-api:${property("deps.permissions_api")}") {
    isTransitive = false
}
```

## Run configurations broken

To regenerate them:

1. Delete `.idea/runConfigurations`
2. Reload the Gradle project
3. Reload `.idea` from disk (or restart IntelliJ)
