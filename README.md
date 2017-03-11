#THIS ADDON IS IN ALPHA. EXPECT THINGS TO GO WRONG.

Hey there! Have you ever wanted your weapon to stay sheathed, but you don't have the keybinds for it? Do you double jump and glide a lot on your demon hunter and get annoyed that your weapons are always out? Do you want your weapon to sheath back after you finish fighting something rather than immediately teleporting onto your back when you loot? Then this is the addon for you!

This is an addon I basically modified from [StayUnsheathed](https://mods.curse.com/addons/wow/stay-sheathed), another addon that does pretty much the exact opposite of this one. What my variation does is checks every 10 seconds to see if your weapon is sheathed, as well as calls upon a limited number of events to try to sheath the weapon. I'm not actually very good at coding at all, so I can't make it as complicated as I want, but I'm trying to learn more to make it so.

Future plans:

* On top of checking every 10 seconds out of combat, run a timer that triggers upon exiting combat to sheath the weapon rather than immediately sheath.
* Add an interface options menu to choose which events you want your weapon sheathed or unsheathed, ie in a city - always unsheath, indoors - sheath, choose a sheath timer, and eventually combine it with the addon StayUnsheathed (so that the option to always check to unsheath as well.)
* Create a profiling system that will allow you to make profiles for aforementioned options because some classes will behave differently. Some class specs (like windwalker monk with fist weapons) may want to always have their weapons drawn.
* Create a button in the character tab, dressing room, transmog room, and plugins for other addons like [MogIt](https://mods.curse.com/addons/wow/mogit) to sheath or unsheath the weapon.

Big shout out to /u/AfterAfterlife, /u/not_a_miner, (Istaran | Medivh - EU for the [initial inspiration](https://mods.curse.com/addons/wow/helm)), and definitely Zordiak Darkspear-US for the [StayUnsheathed](https://mods.curse.com/addons/wow/stay-sheathed) code which I ripped this off from. Like literally if you look at all the Lua, it's pretty much identical with everything, just switched around and altered. Please go support the original addon author here: [AddOn Page because the link expires etc](https://mods.curse.com/addons/wow/stay-sheathed).

**Inspiration**: Helm was an addon I loved very dearly, and I'm very sad to see it go away. It essentially made you "equip" your helmet upon entering combat, and "unequip" your helmet after x amount of seconds leaving combat. Seeing it go inspired me to want to make an addon which would do the same for the sheathing functionality of a weapon.

**KNOWN ISSUES**:

* Sometimes, seemingly randomly upon dismounting and going indoors, you'll unsheath your weapon.
* If you manage to sheath your weapon before combat has ended (having previously been in combat) you will unsheath your weapon.
Sometimes your weapons will appear to be unsheathed and broken when the ToggleSheath even collides with something that would have teleport-sheathed your weapons. There's no real way to fix this except for sheathing and unsheathing your weapons manually or triggering the effect.
* Some of the /sheath functions may or may not work because they were meant to be functioning for StayUnsheathed. They SHOULD work, though, but opposite.

Also I think it should go without saying, but just anyway, this addon + StayUnsheathed will definitely break, and Sheath will overwrite the actions of StaySheathed. I tried to make sure their SavedVariables don't conflict, though, so this (shouldn't) won't mess up any potential profiles StayUnsheathed may add in the future. I also tried to enable both at the same time to watch my sheathing go crazy, but it just sits there. :)
