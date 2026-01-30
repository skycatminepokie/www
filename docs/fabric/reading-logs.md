---
title: Reading Minecraft Logs
authors:
  - skycatminepokie
---

# Reading Minecraft Logs

This page is intended mostly for non-technical users - those who have never programmed before, and aren't used to seeing
stack traces. It may still be useful for developers or those who know more of what they are doing.

[TOC]

## What is all this code???

Chances are, you see something like this:

```text
Reported exception thrown!
net.minecraft.class_148: Rendering screen
	at net.minecraft.client.gui.screen.Screen.wrapScreenError:L436
	at net.minecraft.client.Mouse.onMouseButton:L107
	at net.minecraft.client.Mouse.method_22686:L196
	at net.minecraft.util.thread.ThreadExecutor.execute:L108
	at net.minecraft.client.Mouse.method_22684:L196
	at org.lwjgl.glfw.GLFWMouseButtonCallbackI.callback:L43
	at org.lwjgl.system.JNI.invokeV:native
	at org.lwjgl.glfw.GLFW.glfwWaitEventsTimeout:L3509
	at com.mojang.blaze3d.systems.RenderSystem.limitDisplayFPS:L184
	at net.minecraft.client.MinecraftClient.render:L1310
	at net.minecraft.client.MinecraftClient.run:L882
	at net.minecraft.client.main.Main.main:L256
	at net.fabricmc.loader.impl.game.minecraft.MinecraftGameProvider.launch:L514
	at net.fabricmc.loader.impl.launch.knot.Knot.launch:L72
	at net.fabricmc.loader.impl.launch.knot.KnotClient.main:L23
	at jdk.internal.reflect.DirectMethodHandleAccessor.invoke:unknown
	at java.lang.reflect.Method.invoke:unknown
	at com.modrinth.theseus.MinecraftLaunch.relaunch:L63
	at com.modrinth.theseus.MinecraftLaunch.main:L28
Caused by: java.nio.BufferOverflowException
	at java.nio.Buffer.nextPutIndex:unknown
	at java.nio.DirectByteBuffer.putFloat:unknown
	at com.mr_toad.gpu_booster.api.util.BatchVertexConsumer.method_22912:L75
	at net.minecraft.client.render.VertexConsumer.vertex:L531
	at net.minecraft.client.font.GlyphRenderer.handler$fko000$gpu_booster$batchDraw:L537
	at knot/net.minecraft.class_382.method_2025(class_382.java) 
	at net.minecraft.client.font.TextRenderer.drawGlyph:L303
	at net.minecraft.client.font.TextRenderer$Drawer.accept:class_327:232
	at net.minecraft.text.TextVisitFactory.visitRegularCharacter:L17
	at net.minecraft.text.TextVisitFactory.visitForwards:L43
	at net.minecraft.text.OrderedText.method_30753:L23
	at net.minecraft.client.font.TextRenderer.drawLayer:L298
	at net.minecraft.client.font.TextRenderer.drawInternal:L151
	at net.minecraft.client.font.TextRenderer.draw:L84
	at net.minecraft.client.gui.DrawContext.drawText:L290
	at net.minecraft.client.gui.DrawContext.drawTextWithShadow:L286
	at net.minecraft.client.gui.DrawContext.drawCenteredTextWithShadow:L268
	at com.aetherteam.aether.client.event.hooks.GuiHooks.drawTrivia:L182
	at com.aetherteam.aether.client.event.listeners.GuiListener.onGuiDraw:L65
	at com.aetherteam.aether.client.event.listeners.GuiListener.lambda$listen$0:L31
	at net.fabricmc.fabric.impl.client.screen.ScreenEventFactory.lambda$createAfterRenderEvent$4:L48
	at net.minecraft.client.render.GameRenderer.wrapOperation$fbl000$fabric-screen-api-v1$onRenderScreen(GameRenderer.java:9587) 
	at knot/net.minecraft.class_757.mixinextras$bridge$wrapOperation$fbl000$fabric-screen-api-v1$onRenderScreen$344(class_757.java) 
	at net.minecraft.client.render.GameRenderer.wrapOperation$fgg000$fancymenu$wrapRenderScreenFancyMenu:L11071
	at knot/net.minecraft.class_757.mixinextras$bridge$wrapOperation$fgg000$fancymenu$wrapRenderScreenFancyMenu$346(class_757.java) 
	at net.minecraft.client.render.GameRenderer.wrapOperation$ggi000$konkrete$wrapRenderScreen_Konkrete:L14623
	at net.minecraft.client.render.GameRenderer.render:L913
	at net.minecraft.client.MinecraftClient.render:L1285
	at net.minecraft.client.MinecraftClient.setScreenAndRender:L2322
	at net.minecraft.client.gui.screen.world.CreateWorldScreen.showMessage:L412
	at net.minecraft.client.gui.screen.world.CreateWorldScreen.create:L305
	at net.minecraft.client.gui.screen.world.SelectWorldScreen.method_19944:L54
	at net.minecraft.client.gui.widget.ButtonWidget.onPress:L96
	at net.minecraft.client.gui.widget.PressableWidget.onClick:L48
	at net.minecraft.client.gui.widget.ClickableWidget.mouseClicked:L141
	at net.minecraft.client.gui.ParentElement.mouseClicked:L38
	at net.minecraft.client.Mouse.method_1611:L107
	at net.minecraft.client.gui.screen.Screen.wrapScreenError:L431
	... 18 more
```

And that means a whole lot of nothing to you. So let's break it down.

| What it says                                  | What it means                                               |
|-----------------------------------------------|-------------------------------------------------------------|
| `Reported exception thrown!`                  | "We had a problem"                                          |
| `net.minecraft.class_148: Rendering screen`   | "I was trying to show you the screen"                       |
| `at ...`                                      | "And I was told to do that by this"                         |
| `at ...`                                      | "And I was told to do *that* by this..."                    |
| `Caused by: java.nio.BufferOverflowException` | "And the problem happened because of this other problem..." |

OK, so now we know what the program is saying. But where's the problem *really* coming from?

## Look for Mod IDs

All mods have an "id." This is usually a shortened form of their name. Fabric uses it to tell if two mod `.jar` files
are the same mod (and different versions), or just different mods entirely. Let's look at a few examples:

| Mod                                                             | Mod ID                      |
|-----------------------------------------------------------------|-----------------------------|
| [Fabric API](https://modrinth.com/mod/fabric-api)               | `fabric-api`                |
| [YetAnotherConfigLib (YACL)](https://modrinth.com/mod/yacl)     | `yet_another_config_lib_v3` |
| [Oh The Biomes You'll Go](https://modrinth.com/mod/biomesyougo) | `byg`                       |

As you can see, some are a little more understandable than others. Very rarely, you'll find mods that have ids that are
entirely different from their name - usually this is because they renamed the mod, but mod ids aren't supposed to
change, so they kept the old id.

What can you find in our example that looks like a mod id?

```text
Caused by: java.nio.BufferOverflowException
	at java.nio.Buffer.nextPutIndex:unknown
	at java.nio.DirectByteBuffer.putFloat:unknown
	at com.mr_toad.gpu_booster.api.util.BatchVertexConsumer.method_22912:L75 // gpu_booster is a mod id
	at net.minecraft.client.render.VertexConsumer.vertex:L531
	at net.minecraft.client.font.GlyphRenderer.handler$fko000$gpu_booster$batchDraw:L537
	at knot/net.minecraft.class_382.method_2025(class_382.java) 
	at net.minecraft.client.font.TextRenderer.drawGlyph:L303
	at net.minecraft.client.font.TextRenderer$Drawer.accept:class_327:232
	at net.minecraft.text.TextVisitFactory.visitRegularCharacter:L17
	at net.minecraft.text.TextVisitFactory.visitForwards:L43
	at net.minecraft.text.OrderedText.method_30753:L23
	at net.minecraft.client.font.TextRenderer.drawLayer:L298
	at net.minecraft.client.font.TextRenderer.drawInternal:L151
	at net.minecraft.client.font.TextRenderer.draw:L84
	at net.minecraft.client.gui.DrawContext.drawText:L290
	at net.minecraft.client.gui.DrawContext.drawTextWithShadow:L286
	at net.minecraft.client.gui.DrawContext.drawCenteredTextWithShadow:L268
	at com.aetherteam.aether.client.event.hooks.GuiHooks.drawTrivia:L182 // aether is a mod id
	at com.aetherteam.aether.client.event.listeners.GuiListener.onGuiDraw:L65
	at com.aetherteam.aether.client.event.listeners.GuiListener.lambda$listen$0:L31
	at net.fabricmc.fabric.impl.client.screen.ScreenEventFactory.lambda$createAfterRenderEvent$4:L48
	at net.minecraft.client.render.GameRenderer.wrapOperation$fbl000$fabric-screen-api-v1$onRenderScreen(GameRenderer.java:9587)  // fabric-screen-api-v1 is a mod id
	at knot/net.minecraft.class_757.mixinextras$bridge$wrapOperation$fbl000$fabric-screen-api-v1$onRenderScreen$344(class_757.java)  // fabric-screen-api-v1 is a mod id
	at net.minecraft.client.render.GameRenderer.wrapOperation$fgg000$fancymenu$wrapRenderScreenFancyMenu:L11071 // fancymenu is a mod id
	at knot/net.minecraft.class_757.mixinextras$bridge$wrapOperation$fgg000$fancymenu$wrapRenderScreenFancyMenu$346(class_757.java)  // fancymenu is a mod id
	at net.minecraft.client.render.GameRenderer.wrapOperation$ggi000$konkrete$wrapRenderScreen_Konkrete:L14623 // konkrete is a mod id
	at net.minecraft.client.render.GameRenderer.render:L913
	at net.minecraft.client.MinecraftClient.render:L1285
	at net.minecraft.client.MinecraftClient.setScreenAndRender:L2322
	at net.minecraft.client.gui.screen.world.CreateWorldScreen.showMessage:L412
	at net.minecraft.client.gui.screen.world.CreateWorldScreen.create:L305
	at net.minecraft.client.gui.screen.world.SelectWorldScreen.method_19944:L54
	at net.minecraft.client.gui.widget.ButtonWidget.onPress:L96
	at net.minecraft.client.gui.widget.PressableWidget.onClick:L48
	at net.minecraft.client.gui.widget.ClickableWidget.mouseClicked:L141
	at net.minecraft.client.gui.ParentElement.mouseClicked:L38
	at net.minecraft.client.Mouse.method_1611:L107
	at net.minecraft.client.gui.screen.Screen.wrapScreenError:L431
	... 18 more
```

Sweet! We've found some mod ids. Now it's time to apply some intuition to find the culprit.

## Rules of Thumb

These rules can help you guess at what mod to try removing (or updating). They're not foolproof, and are generally for
crashes where all dependencies are met (meaning you've installed all the mods that other mods need).

1. Higher up = more likely. Remember that `at...` is the program saying "and I was told to do that by..." Chances are,
   the uppermost mod is at fault.
2. Relevant error types. This one is more for the technical. In this case, I happen to know that a
   `BufferOverflowException` is caused by something messing very close to memory, such as an optimization mod or
   something that messes with rendering or hardware.
3. `mixinextras...wrapOperation` = less likely. This is used by mods that are trying to be careful about what they
   change, but it will show up in the logs a lot because of how it works, even if the mod doesn't choose to change
   anything this time around.
4. It's probably not Fabric API. Fabric API does have bugs, but they're usually fixed quickly. Most of Fabric API is
   automatically tested, and all of it is reviewed by multiple people before being published.

## So what's up with this log?

In our example, we've got quite a bit to work with. Right before crashing, we see `Reported exception thrown!`.
Minecraft knows it has crashed! That's pretty helpful. We know it was `Rendering screen`, and that the error was
`Caused by: java.nio.BufferOverflowException`. Just three lines down, we see `at com.mr_toad.gpu_booster.api.util...`.
Looks like GPU Booster is probably the cause. The user removed GPU Booster from their mods, and now the game works!
