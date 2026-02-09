# Layout & Anchoring Patterns

FGU uses an anchor-based positioning system, not CSS flexbox. Every element is explicitly positioned relative to its parent or siblings using `<anchored>` tags.

## Quick Reference

### Position Keywords

| Keyword | Meaning |
|---------|---------|
| `insidetopleft` | Inside parent, top-left corner |
| `insidetopright` | Inside parent, top-right corner |
| `insidetop` | Inside parent, top edge (horizontally centered) |
| `insidebottomleft` | Inside parent, bottom-left corner |
| `insidebottomright` | Inside parent, bottom-right corner |
| `righthigh` | Adjacent right, aligned at top |
| `rightlow` | Adjacent right, aligned at bottom |
| `right` | Adjacent right (no vertical alignment) |
| `lefthigh` | Adjacent left, aligned at top |
| `leftlow` | Adjacent left, aligned at bottom |
| `left` | Adjacent left (no vertical alignment) |
| `below` | Directly below target |
| `above` | Directly above target |
| `aboveright` | Above target, right-aligned |
| `aboveleft` | Above target, left-aligned |

### Anchor Attributes

| Attribute | Purpose |
|-----------|---------|
| `to="name"` | Position relative to named sibling |
| `offset="x,y"` | Pixel offset from anchor point |
| `offset="N%"` | Percentage offset from parent edge |
| `width="N"` | Fixed width in pixels |
| `height="N"` | Fixed height in pixels |
| `width="-1"` | Fill remaining space (use with sizelimits) |
| `parent=""` | Reference window itself (empty string) |
| `parent="name"` | Reference named sibling for edge anchoring |

### Edge Anchoring

| Attribute | Purpose |
|-----------|---------|
| `anchor="left"` | Anchor to left edge of target |
| `anchor="right"` | Anchor to right edge of target |
| `anchor="top"` | Anchor to top edge of target |
| `anchor="bottom"` | Anchor to bottom edge of target |
| `anchor="center"` | Anchor to center of parent (for split layouts) |

### Relation Types

| Value | Behavior |
|-------|----------|
| `relation="relative"` | Stack sequentially; each control advances the anchor point |
| `relation="current"` | Fill space; don't advance anchor point |

### Offset vs Postoffset

| Attribute | When Applied |
|-----------|--------------|
| `offset="N"` | Margin **before** the element |
| `postoffset="N"` | Margin **after** the element (advances anchor for next control) |

### Responsive Sizing

| Edges Specified | Result |
|-----------------|--------|
| `<left>` + `<right>` | Width expands/contracts with parent |
| `<top>` + `<bottom>` | Height expands/contracts with parent |
| All four edges | Fully responsive to parent size |

---

## Basic Patterns

### Invisible Anchor Points

**Problem:** Need reference points for positioning elements from left/right edges without visible controls.

**Source:** `references/CapitalGains/campaign/record_resource.xml` (lines 7-13, 32-38)

**Verified:** 2026-01-26

```xml
<genericcontrol name="rightanchor">
	<anchored width="0" height="0">
		<top />
		<right />
	</anchored>
	<invisible />
</genericcontrol>
```

```xml
<genericcontrol name="leftanchor">
	<anchored width="0" height="0">
		<top />
		<left />
	</anchored>
	<invisible />
</genericcontrol>
```

**Key Points:**
- `width="0" height="0"` creates a zero-size reference point
- `<invisible />` hides from rendering (recommended for anchors)
- `<top />` and `<right />` (or `<left />`) positions at corner
- Other elements use `to="rightanchor"` to position relative to this point

**`<invisible />` vs `<disabled />` vs no modifier:**

| Modifier | Semantic Meaning | When to Use |
|----------|------------------|-------------|
| `<invisible />` | Control should not render | **Recommended** for anchors |
| No modifier | Default visibility | Acceptable for zero-size controls |
| `<disabled />` | Control should not accept input | Incorrect semantics for anchors |

**Evidence from references:**
- `references/CapitalGains/campaign/record_resource.xml` lines 7-13: uses `<invisible />`
- `references/CapitalGains/campaign/record_power_roll.xml` lines 42-47: uses no modifier
- `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` lines 101-107: uses `<invisible />`


---

### Horizontal Chaining (Row Layout)

**Problem:** Position elements in a horizontal row, each relative to the previous.

**Source:** `references/CapitalGains/campaign/record_resource.xml` (lines 196-207)

**Verified:** 2026-01-26

```xml
<label name="gainperiodlabel">
	<anchored to="columnanchor" height="20">
		<left offset="5" />
		<top anchor="bottom" relation="relative" offset="5" />
	</anchored>
	<static textres="resource_gain_period_label" />
</label>
<combobox name="gainperiod">
	<anchored to="gainperiodlabel" position="righthigh" width="100" height="20" offset="10,0" />
</combobox>
<label name="label_gainall">
	<anchored to="gainperiod" position="righthigh" offset="15,0" height="20" />
	<static textres="power_resource_all_label" />
</label>
<button_checkbox name="gainall">
	<anchored to="label_gainall" position="righthigh" offset="0,0" width="20" height="20" />
</button_checkbox>
```

**Key Points:**
- `position="righthigh"` places element to the right, aligned at top
- `to="previous_element"` chains to the prior control
- `offset="10,0"` adds horizontal gap (x,y)
- Each element specifies its own `width` and `height`


---

### Vertical Stacking (Column Layout)

**Problem:** Stack elements vertically, each below the previous.

**Source:** `references/FG-2e-PlayersOption/campaign/record_char_main.xml`

**Verified:** 2026-01-26

```xml
<number_charabilityscore2 name="comeliness" source="abilities.comeliness.score">
    <anchored to="charisma" position="below" offset="0,5" height="36"/>
</number_charabilityscore2>

<number_honor name="honor" source="abilities.honor.score">
    <anchored to="comeliness" position="below" offset="0,5" height="36"/>
</number_honor>
```

**Key Points:**
- `position="below"` places element directly under the target
- `to="previous_element"` specifies which element to stack under
- `offset="0,5"` adds vertical gap (x=0, y=5)
- Creates a vertical chain: charisma → comeliness → honor


---

### Responsive Fill (Expand to Container)

**Problem:** Make a control expand to fill the available horizontal space.

**Source:** `references/CapitalGains/campaign/record_resource.xml` (lines 66-72)

**Verified:** 2026-01-26

```xml
<stringu name="name">
	<anchored height="20">
		<top offset="5" />
		<left parent="leftanchor" anchor="right" relation="relative" offset="5" />
		<right parent="rightanchor" anchor="left" relation="relative" offset="0" />
	</anchored>
</stringu>
```

**Key Points:**
- Specifying both `<left>` and `<right>` makes width responsive
- `parent="leftanchor"` references an invisible anchor control
- `anchor="right"` means "my left edge anchors to the right edge of leftanchor"
- `relation="relative"` means offset is relative to the anchor
- Width = (rightanchor.left - leftanchor.right - offsets)


---

### Column Anchor for Vertical Flow

**Problem:** Create a reference point for stacking elements vertically in sequence.

**Source:** `references/CapitalGains/campaign/record_char_actions.xml` (line 36)

**Verified:** 2026-01-26

```xml
<anchor_column name="columnanchor" />
```

Then used by child elements:

```xml
<label_charframetop name="resourcestitle">
	<anchored height="20">
		<top parent="columnanchor" anchor="bottom" relation="relative" offset="15" />
		<left offset="15" />
		<right offset="-10" />
	</anchored>
</label_charframetop>
```

**Key Points:**
- `<anchor_column>` is a predefined FGU template for column flow
- Elements use `<top parent="columnanchor" anchor="bottom" relation="relative" />`
- This means "position my top at the bottom of the previous element"
- Creates automatic vertical stacking without explicit `position="below"`


---

### Positioning from Right Edge

**Problem:** Position a control relative to the right edge of its container.

**Source:** `references/CapitalGains/campaign/record_resource.xml` (lines 14-18)

**Verified:** 2026-01-26

```xml
<button_idelete name="idelete">
	<anchored to="rightanchor">
		<top offset="5" />
		<right anchor="left" relation="relative" offset="-2" />
	</anchored>
</button_idelete>
```

**Key Points:**
- First create an invisible `rightanchor` at `<top /><right />`
- Then use `to="rightanchor"` to position relative to it
- `<right anchor="left" relation="relative" offset="-2" />` means "my right edge is 2px left of rightanchor's left edge"
- Button stays pinned to right side as container resizes


---

## Advanced Patterns

### Split Layout (Two-Column Responsive)

**Problem:** Divide a window into left and right panels that share the space equally.

**Source:** `references/CoreRPG/layout/template_layout_content_misc.xml` (lines 136-199)

**Verified:** 2026-02-04

```xml
<!-- LEFT PANEL: from left edge to center -->
<template name="area_content_left">
	<area_content>
		<anchored>
			<right anchor="center" />
		</anchored>
	</area_content>
</template>

<!-- RIGHT PANEL: from center to right edge -->
<template name="area_content_right">
	<area_content>
		<anchored>
			<left anchor="center" />
		</anchored>
	</area_content>
</template>
```

**Key Points:**
- `anchor="center"` divides the parent at its midpoint
- Left panel: `<right anchor="center" />` - right edge stops at center
- Right panel: `<left anchor="center" />` - left edge starts at center
- Both panels resize proportionally when window resizes
- This is the closest FGU gets to a "50/50 split" layout


---

### Flex-Width with Maximum Constraint

**Problem:** Create a control that fills available space but has a maximum width.

**Source:** `references/CoreRPG/layout/template_layout_content_list_item_specific.xml` (lines 86-108)

**Verified:** 2026-02-04

```xml
<stringc_masterindexitem_category>
	<stringc>
		<anchored width="-1">
			<sizelimits><maximum width="150" /></sizelimits>
		</anchored>
	</stringc>
</stringc_masterindexitem_category>
```

**Key Points:**
- `width="-1"` means "fill remaining horizontal space"
- `<sizelimits><maximum width="150" /></sizelimits>` caps the width
- Control expands to fill space, but never exceeds 150px
- Useful for labels/fields that should grow but not dominate


---

### Postoffset for Automatic Spacing

**Problem:** Add consistent spacing after elements in a vertical flow without manual offset calculations.

**Source:** `references/CoreRPG/layout/template_layout_content_filter.xml` (lines 10-18)

**Verified:** 2026-02-04

```xml
<anchored to="contentanchor">
	<top relation="relative" offset="5" postoffset="10" />
	<left offset="30" />
	<right offset="-10" />
</anchored>
```

**Key Points:**
- `offset="5"` adds 5px margin **before** the element
- `postoffset="10"` adds 10px margin **after** the element
- The postoffset advances the anchor point for the next `relation="relative"` element
- Eliminates need to calculate cumulative offsets manually
- Pattern: `offset` = top margin, `postoffset` = bottom margin


---

### Right-to-Left Stacking

**Problem:** Build a row of controls from right to left (e.g., right-aligned button groups).

**Source:** `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` (lines 38-73)

**Verified:** 2026-02-04

```xml
<!-- Create right anchor point -->
<genericcontrol name="rightanchor">
	<anchored to="configframe" width="0" height="0">
		<top />
		<right offset="-10" />
	</anchored>
	<invisible />
</genericcontrol>

<!-- First control from right -->
<label name="shift_label">
	<anchored to="configframe" width="50" height="20">
		<top offset="40" />
		<right parent="rightanchor" anchor="left" relation="relative" offset="-17" />
	</anchored>
</label>

<!-- Second control, further left -->
<label name="duration_label">
	<anchored to="configframe" width="50" height="20">
		<top offset="40" />
		<right parent="rightanchor" anchor="left" relation="relative" offset="-4" />
	</anchored>
</label>
```

**Key Points:**
- Create a `rightanchor` at the right edge
- Each control uses `<right parent="rightanchor" anchor="left" relation="relative" />`
- Controls stack leftward from the right edge
- Useful for toolbars, button groups, or right-aligned columns


---

### Framed Groupbox with Internal Padding

**Problem:** Create a bordered section with consistent internal margins.

**Source:** `references/CoreRPG/layout/template_layout_content_list.xml` (lines 79-135)

**Verified:** 2026-02-04

```xml
<template name="list_content_framed_groupbox_base">
	<windowlist name="list">
		<anchored to="contentanchor">
			<left offset="15" />
			<right offset="-25" />
		</anchored>
		<frame name="groupbox" offset="15,15,25,15" />
	</windowlist>
</template>
```

**Key Points:**
- `<frame name="groupbox" offset="15,15,25,15" />` creates the border
- Frame offset format: `left, top, right, bottom` (internal padding)
- The anchored offsets position the frame within the parent
- Content inside the frame is inset by the frame's offset values
- Combine with split layout for left/right groupboxes:

```xml
<template name="list_content_framed_groupbox_left">
	<list_content_framed_groupbox>
		<anchored>
			<right anchor="center" offset="-25" />
		</anchored>
	</list_content_framed_groupbox>
</template>
```


---

## Programmatic Patterns

### Dynamic Sizing in Lua

**Problem:** Resize controls at runtime based on content or other factors.

**Source:** `references/CoreRPG/desktop/scripts/characterlist.lua` (lines 59-75)

**Verified:** 2026-02-04

```lua
function onContentSizeChanged(nW, nH)
	content.setAnchoredWidth(nW);
	content.setAnchoredHeight(nH);
	self.refreshSize();
end

function refreshSize()
	local nW = content.getAnchoredWidth();
	local nH = content.getAnchoredHeight();
	setSize(nW + self.BUTTON_PADDING, nH);
end
```

**Key Points:**
- `setAnchoredWidth(n)` / `setAnchoredHeight(n)` resize a control
- `getAnchoredWidth()` / `getAnchoredHeight()` read current size
- `setSize(w, h)` resizes a window
- Use sparingly - prefer XML anchoring when possible

**Available Lua sizing methods:**
- `control.setAnchoredWidth(n)` - Set width
- `control.setAnchoredHeight(n)` - Set height
- `control.getAnchoredWidth()` - Get current width
- `control.getAnchoredHeight()` - Get current height
- `window.setSize(w, h)` - Set window dimensions


---

### Layout Constants in Lua

**Problem:** Define consistent spacing/sizing values for programmatic layout.

**Source:** `references/CoreRPG/scripts/manager_list.lua` (lines 10-29)

**Verified:** 2026-02-04

```lua
DEFAULT_START_WIDTH = 350;
DEFAULT_START_HEIGHT = 450;
DEFAULT_ROW_SIZE = 24;
DEFAULT_COL_WIDTH = 50;
DEFAULT_COL_PADDING = 5;
```

**Key Points:**
- Define constants for reusable spacing values
- Keeps layout calculations consistent across functions
- Easier to adjust spacing globally


---

## Container Patterns

### Windowlist with Responsive Sizing

**Problem:** Create a dynamic list that fills available space and responds to parent size.

**Source:** `references/CapitalGains/campaign/record_char_actions.xml` (lines 67-96)

**Verified:** 2026-01-26

```xml
<windowlist name="list">
	<script>
		function addEntry(bFocus)
			local w = createWindow();
			if bFocus then
				w.name.setFocus();
			end
			return w;
		end
		function update(bEditMode)
			for _,w in pairs(getWindows()) do
				w.idelete.setVisibility(bEditMode);
			end
		end
	</script>
	<anchored>
		<top parent="columnanchor" anchor="bottom" relation="relative" offset="5" />
		<left offset="6" />
		<right offset="3" />
	</anchored>
	<skipempty />
	<datasource>.resources</datasource>
	<class>resource_item</class>
	<columns width="192" fillwidth="true" />
	<sortby><field>name</field></sortby>
	<noscroll />
	<allowcreate />
	<allowdelete />
	<footer>footer_wide</footer>
</windowlist>
```

**Key Points:**
- `<left offset="6" />` and `<right offset="3" />` make width responsive
- `<columns width="192" fillwidth="true" />` sets row width behavior
- `fillwidth="true"` expands rows to fill available width
- `<allowcreate />` and `<allowdelete />` enable add/remove


---

### Subwindow Embedding

**Problem:** Embed one windowclass inside another for modular composition.

**Source:** `references/CapitalGains/campaign/record_char_actions.xml` (lines 21-30)

**Verified:** 2026-01-26

```xml
<subwindow name="resources" insertbefore="actions">
	<anchored>
		<top parent="columnanchor" anchor="bottom" relation="relative" offset="0" />
		<left />
		<right />
	</anchored>
	<activate />
	<fastinit />
	<class>char_power_resources</class>
</subwindow>
```

**Key Points:**
- `<class>char_power_resources</class>` specifies which windowclass to embed
- `<anchored>` with `<left />` and `<right />` makes it fill parent width
- `<activate />` enables the subwindow
- `<fastinit />` initializes immediately
- `insertbefore="actions"` controls ordering in merged windowclasses


---

## Sizing Guidelines

### Fixed vs Responsive Sizing

**Problem:** Deciding whether to use fixed pixel dimensions or responsive anchoring.

**Research Date:** 2026-01-26

**Use Fixed Sizing For:**

| Element Type | Reason |
|--------------|--------|
| Buttons, icons | Icon size is constant |
| Number fields (1-3 digits) | Content length is predictable |
| Abbreviation labels ("STR", "DEX") | Short, known text |
| Checkboxes | Standard size |

**Use Responsive Sizing For:**

| Element Type | Reason |
|--------------|--------|
| Name/title fields | Content varies in length |
| Description/notes | User-entered text varies |
| Lists (windowlist) | Should fill available space |
| Top-level content areas | Adapt to window size |

**Decision Matrix:**

| Content Type | Pattern | Example |
|--------------|---------|---------|
| Button/icon | Fixed `width`+`height` | `width="20" height="20"` |
| Number field | Fixed `width`, fixed `height` | `width="40" height="20"` |
| Short label | Fixed `width` | `width="60"` |
| Text input | Responsive `<left>`+`<right>` | See Responsive Fill |
| Container frame | Fixed if internal layout is fixed | `width="280" height="220"` |
| Windowlist | Responsive | `<left offset="6" /><right offset="3" />` |
| Side-by-side frames | Anchor second to first | `position="righthigh"` |


---

### Window-Level Size Limits

**Source:** `references/CapitalGains/campaign/record_resource.xml` (lines 79-84)

**Verified:** 2026-01-26

```xml
<placement>
	<size width="350" height="350" />
</placement>
<sizelimits>
	<minimum width="300" height="300" />
	<dynamic />
</sizelimits>
```

**Key Points:**
- `<placement><size>` sets default window size
- `<sizelimits><minimum>` prevents shrinking below content needs
- `<dynamic />` allows user to resize the window larger
- Without `<dynamic />`, window has fixed size


---

## Common Mistakes

### Fixed Offset for Adjacent Frames

**Problem code:**
```xml
<frame_char name="physical_frame">
    <anchored position="insidetopleft" offset="0,0" width="280" height="220" />
</frame_char>
<frame_char name="mental_frame">
    <anchored position="insidetopleft" offset="300,0" width="280" height="220" />
</frame_char>
```

**Issue:** If window is narrower than 580px, `mental_frame` gets clipped.

**Better approach - anchor second frame to first:**
```xml
<frame_char name="physical_frame">
    <anchored position="insidetopleft" offset="0,0" width="280" height="220" />
</frame_char>
<frame_char name="mental_frame">
    <anchored to="physical_frame" position="righthigh" offset="20,0" width="280" height="220" />
</frame_char>
```

**Or use minimum window size to guarantee space:**
```xml
<sizelimits>
    <minimum width="600" height="400" />
</sizelimits>
```


---

## Percentage-Based Positioning

**Problem:** Create proportional multi-column layouts without hardcoded pixel widths.

**Source:** `references/CoreRPG/utility/utility_sound_settings_ss.xml` (lines 14-35)

```xml
<sub_content_top name="sub_system">
    <anchored>
        <right anchor="left" offset="30%" />
    </anchored>
</sub_content_top>
<subwindow name="sub_data">
    <anchored>
        <top parent="sub_system" />
        <left offset="30%" />
        <right anchor="left" offset="65%" />
    </anchored>
</subwindow>
<subwindow name="sub_session">
    <anchored>
        <top parent="sub_system" />
        <left offset="65%" />
        <right offset="-5" />
    </anchored>
</subwindow>
```

**Key Points:**
- Percentage values (`30%`, `65%`) can be used in `offset` attributes
- Creates proportional column layouts (30% / 35% / remaining)
- More flexible than `anchor="center"` for non-equal splits
- Can mix percentage and pixel offsets in the same layout


---

## Legacy Positioning with `<bounds>`

**Problem:** Simple fixed positioning without the complexity of `<anchored>`.

**Source:** `references/CoreRPG/common/template_common.xml` (lines 11-14), `references/CoreRPG/utility/utility_calendar.xml` (lines 379-396)

```xml
<!-- Hidden data field -->
<template name="hn">
    <numberfield>
        <bounds>0,0,0,0</bounds>
        <invisible />
    </numberfield>
</template>

<!-- Fixed position controls -->
<genericcontrol>
    <bounds>10,20,63,63</bounds>
</genericcontrol>
<genericcontrol>
    <bounds>80,23,-10,15</bounds>
</genericcontrol>
```

**Key Points:**
- Format: `<bounds>x, y, width, height</bounds>`
- Negative width/height anchors to opposite edge (`-10` = 10px from right)
- Simpler than `<anchored>` for basic fixed layouts
- Commonly used for hidden data fields (`hn`, `hs`, `hlink` templates)
- Can use `-1` for "fill remaining" dimension


---

## Template Modification

### Merge Attributes

**Problem:** Modify inherited template properties without redefining the entire template.

**Source:** `references/CoreRPG/layout/template_layout_content_list.xml` (lines 45-47), `references/CoreRPG/common/template_column.xml` (line 84)

```xml
<!-- Add alternating row colors -->
<template name="list_content_alternating_top">
    <list_content_top>
        <child merge="resetandadd"></child>
        <child merge="add"><backcolor>1A40301E</backcolor></child>
    </list_content_top>
</template>

<!-- Remove an element from inherited template -->
<string_column>
    <anchored width="60">
        <right merge="delete" />
    </anchored>
</string_column>
```

**Merge Values:**

| Value | Behavior |
|-------|----------|
| `merge="add"` | Add to existing array |
| `merge="resetandadd"` | Clear array, then add |
| `merge="delete"` | Remove the element entirely |
| `merge="replace"` | Replace the element value |
| `mergerule="replace"` | Replace when merging templates |

### Control Ordering with `insertbefore` / `insertafter`

**Problem:** Control element order when extending windowclasses.

**Source:** `references/CoreRPG/utility/utility_assets.xml` (lines 47-55)

```xml
<sub_content_top name="sub_controls_top" insertbefore="bottomanchor">
    ...
</sub_content_top>
<sub_content_buttons_bottom name="sub_buttons" insertbefore="filter">
    ...
</sub_content_buttons_bottom>
```

**Key Points:**
- `insertbefore="controlname"` places element before the named control
- `insertafter="controlname"` places element after the named control
- Critical for proper control ordering in extended windowclasses
- Without these, extended controls appear at end of sheetdata


---

## Window and Control Properties

### Margins

**Problem:** Add consistent spacing around windowclass content or between list items.

**Source:** `references/CoreRPG/utility/utility_assets.xml` (line 66), `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` (line 99)

```xml
<windowclass name="asset_controls_asset">
    <margins control="0,0,0,5" />
    ...
</windowclass>

<windowclass name="moonitem">
    <margins control="0,0,0,2" />
    ...
</windowclass>
```

**Key Points:**
- Format: `<margins control="left,top,right,bottom" />`
- Applied to windowclass content area
- Common pattern: `0,0,0,5` adds 5px bottom margin between list items
- Separate from frame offsets (which create internal padding)

### Parent Reference to Window

**Problem:** Anchor to the window itself while using `to=` for other edges.

**Source:** `references/CoreRPG/utility/utility_assets.xml` (line 502), `references/CoreRPG/common/template_column.xml` (line 50)

```xml
<anchored to="leftanchor">
    <top />
    <left relation="relative" offset="5" postoffset="5" />
    <right parent="" />
</anchored>

<anchored>
    <top />
    <right parent="" offset="-60" />
</anchored>
```

**Key Points:**
- `parent=""` (empty string) references the window/container itself
- Different from `parent="controlname"` which references a sibling
- Useful when anchoring left to a control but right to the window edge

### Non-Persistent Window Position

**Problem:** Utility dialogs should always open in default position.

**Source:** `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` (lines 7-10)

```xml
<placement>
    <size width="480" height="480" />
    <nosave />
</placement>
```

**Key Points:**
- `<nosave />` prevents window position/size from persisting between sessions
- Useful for utility dialogs, popups, and temporary windows


---

## List Features

### Sorting

**Problem:** Automatically sort windowlist items.

**Source:** `references/CoreRPG/utility/utility_options.xml` (line 87), `references/CoreRPG/campaign/record_power_action.xml` (line 19)

```xml
<!-- Sort by control value -->
<windowlist name="list">
    <sortby><control>label</control></sortby>
</windowlist>

<!-- Sort by database field -->
<windowlist>
    <sortby><field>order</field></sortby>
</windowlist>
```

**Key Points:**
- `<sortby><control>name</control></sortby>` - Sort by a control's displayed value
- `<sortby><field>name</field></sortby>` - Sort by a database field
- Multiple `<sortby>` elements for multi-level sorting
- Sorting is automatic when items are added

### Filtering

**Problem:** Allow users to filter list contents by typing.

**Source:** `references/CoreRPG/layout/template_layout_content_list.xml` (lines 130-134)

```xml
<template name="list_content_framed_groupbox_alternating_filtered">
    <list_content_framed_groupbox_alternating>
        <filter control="filter" />
        <filteron control="name" />
    </list_content_framed_groupbox_alternating>
</template>
```

**Key Points:**
- `<filter control="filter" />` - Names the filter input control
- `<filteron control="name" />` - Names the control in each row to filter on
- Multiple `<filteron>` elements for multi-field filtering

### Alternating Row Colors

**Problem:** Create zebra-striped list backgrounds for readability.

**Source:** `references/CoreRPG/layout/template_layout_content_list.xml` (lines 43-47)

```xml
<template name="list_content_alternating_top">
    <list_content_top>
        <child merge="resetandadd"></child>
        <child merge="add"><backcolor>1A40301E</backcolor></child>
    </list_content_top>
</template>
```

**Key Points:**
- Two `<child>` elements create alternating pattern
- First child: no backcolor (transparent)
- Second child: ARGB color (`1A` = alpha, `40301E` = RGB)
- Applied to windowlist rows automatically

### Vertical Column Stacking

**Problem:** Make windowlist items stack vertically then wrap to next column.

**Source:** `references/CoreRPG/campaign/template_char.xml` (line 51)

```xml
<windowlist>
    <columns width="222" filldown="true" dynamic="true" />
</windowlist>
```

**Key Points:**
- `filldown="true"` makes items stack vertically, then wrap to next column
- Without `filldown`, items stack left-to-right, then wrap to next row
- Useful for multi-column skill lists or inventory grids


---

## Control State Frames

**Problem:** Show different visual styles based on control state (hover, focus, drag).

**Source:** `references/CoreRPG/common/template_common.xml` (lines 120-124)

```xml
<basicstring>
    <frame mergerule="replace" name="fielddark" offset="7,5,7,5" hidereadonly="true" />
    <stateframe>
        <keyedit name="fieldfocus" offset="7,5,7,5" />
        <hover name="fieldfocus" offset="7,5,7,5" hidereadonly="true" />
        <drophilight name="fieldfocus" offset="7,5,7,5" hidereadonly="true" />
    </stateframe>
</basicstring>
```

**State Frame Types:**

| Element | When Shown |
|---------|------------|
| `<keyedit>` | Control has keyboard focus |
| `<hover>` | Mouse hovers over control |
| `<drophilight>` | Valid drag content hovers over control |

**Key Points:**
- `hidereadonly="true"` suppresses state frame for readonly controls
- Frame names reference graphics defined in the theme
- All state frames should use matching offsets for consistent sizing


---

## Text and Input Properties

### Line Spacing

**Problem:** Control line height for multi-line text.

**Source:** `references/CoreRPG/common/template_column.xml` (lines 62-63)

```xml
<basicstring>
    <multilinespacing>20</multilinespacing>
</basicstring>
```

**Key Points:**
- Value is line height in pixels
- Affects multi-line text wrapping and display
- Common values: 18-28 depending on font size

### Text Alignment

**Problem:** Center text within a control.

**Source:** `references/CoreRPG/utility/utility_dice.xml` (line 137)

```xml
<label name="label_custom">
    <center />
    <static textres="diceselect_label_custom" />
</label>
```

**Key Points:**
- `<center />` centers text horizontally
- Remove with `<center merge="delete" />` in derived templates

### Dropdown Direction

**Problem:** Control which direction a combobox dropdown opens.

**Source:** `references/CoreRPG/layout/template_layout_content_filter.xml` (line 124), `references/CoreRPG/campaign/template_campaign.xml` (line 337)

```xml
<comboboxc>
    <listdirection>down</listdirection>
    <listmaxsize>4</listmaxsize>
</comboboxc>

<comboboxc>
    <listdirection>up</listdirection>
</comboboxc>
```

**Key Points:**
- `down` - Dropdown opens below (default)
- `up` - Dropdown opens above (useful for bottom-positioned controls)
- `<listmaxsize>N</listmaxsize>` limits visible items in dropdown


---

## Keyboard Navigation

**Problem:** Define Tab key navigation order between controls.

**Source:** `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` (lines 120-137)

```xml
<number_moon name="shift">
    <tabtarget prev="duration" />
</number_moon>
<number_moon name="duration">
    <tabtarget next="shift" prev="period" />
</number_moon>
<number_moon name="period">
    <tabtarget next="duration" prev="name"/>
</number_moon>
```

**Key Points:**
- `next="controlname"` - Control to focus on Tab
- `prev="controlname"` - Control to focus on Shift+Tab
- Creates a tab navigation cycle within a window
- Improves keyboard accessibility


---

## Additional Lua Layout Methods

### Static Bounds

**Problem:** Set absolute position/size programmatically.

**Source:** `references/CoreRPG/scripts/manager_characterlist.lua` (line 97)

```lua
w.anchor.setStaticBounds(
    CharacterListManager.LEFT_MARGIN - CharacterListManager.PORTRAIT_PADDING_W,
    CharacterListManager.TOP_MARGIN,
    0,
    0
);
```

**Key Points:**
- `control.setStaticBounds(x, y, w, h)` sets absolute position and size
- Overrides XML anchoring for that control
- Use sparingly - prefer XML anchoring when possible

### Widget Positioning

**Problem:** Position widgets (bitmaps, text) within a control.

**Source:** `references/CoreRPG/scripts/manager_token.lua` (line 1105), `references/CoreRPG/common/scripts/buttongroup_tabs.lua` (lines 300-302)

```lua
widgetHealthBar.setPosition("right", TokenManager.TOKEN_HEALTHBAR_HOFFSET, 0);

wgt.setPosition("topleft", (_nTabSize * (nIndex - 1)) + offset[1], offset[2]);
```

**Key Points:**
- First parameter: anchor point (`"topleft"`, `"right"`, `"center"`, etc.)
- Second/third parameters: x,y offsets from anchor
- Used for widgets within controls, not controls themselves

### Full Lua Sizing API

```lua
-- Control sizing
control.setAnchoredWidth(n)      -- Set width
control.setAnchoredHeight(n)     -- Set height
control.getAnchoredWidth()       -- Get current width
control.getAnchoredHeight()      -- Get current height

-- Static positioning (overrides XML)
control.setStaticBounds(x, y, w, h)

-- Window sizing
window.setSize(w, h)             -- Set window dimensions
window.getSize()                 -- Returns w, h

-- Widget positioning
widget.setPosition(anchor, x, y)
widget.getPosition()             -- Returns anchor, x, y
```
