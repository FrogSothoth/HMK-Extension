# Layout & Anchoring Patterns

FGU uses an anchor-based positioning system, not CSS flexbox. Every element is explicitly positioned relative to its parent or siblings using `<anchored>` tags.

## Quick Reference

### Position Keywords

| Keyword | Meaning |
|---------|---------|
| `insidetopleft` | Fixed offset from parent's top-left corner |
| `insidetopright` | Fixed offset from parent's top-right corner |
| `righthigh` | To the right of target, aligned at top |
| `rightlow` | To the right of target, aligned at bottom |
| `below` | Directly below target |
| `above` | Directly above target |

### Anchor Attributes

| Attribute | Purpose |
|-----------|---------|
| `to="name"` | Position relative to named sibling |
| `offset="x,y"` | Pixel offset from anchor point |
| `width="N"` | Fixed width in pixels |
| `height="N"` | Fixed height in pixels |

### Responsive Sizing

| Edges Specified | Result |
|-----------------|--------|
| `<left>` + `<right>` | Width expands/contracts with parent |
| `<top>` + `<bottom>` | Height expands/contracts with parent |
| All four edges | Fully responsive to parent size |

---

## Patterns

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

Zero-size anchor controls can use any of these approaches:

| Modifier | Semantic Meaning | When to Use |
|----------|------------------|-------------|
| `<invisible />` | Control should not render | **Recommended** for anchors - explicit intent |
| No modifier | Default visibility | Acceptable for zero-size controls (they render nothing anyway) |
| `<disabled />` | Control should not accept input | Incorrect semantics for anchors (but works functionally) |

**Evidence from references:**
- `references/CapitalGains/campaign/record_resource.xml` lines 7-13: uses `<invisible />`
- `references/CapitalGains/campaign/record_power_roll.xml` lines 42-47: uses no modifier
- `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` lines 101-107: uses `<invisible />`

**Note:** `<disabled />` is semantically for controls that are visible but shouldn't accept user input (e.g., decorative frames). Using it for zero-size anchors works but is misleading. Prefer `<invisible />` for clarity.


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
	<listdirection>down</listdirection>
	<listmaxsize>12</listmaxsize>
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

**Source:** `references/FG-2e-PlayersOption/campaign/record_char_main.xml` (grep result)

**Verified:** 2026-01-26

```xml
<number_charabilityscore2 name="comeliness" source="abilities.comeliness.score" insertafter="charisma_reaction">
    <tooltip textres="char_tooltip_comeliness" />
    <anchored to="charisma" position="below" offset="0,5" height="36"/>
    <target>comeliness</target>
</number_charabilityscore2>
```

```xml
<number_honor name="honor" source="abilities.honor.score">
    <tooltip textres="char_tooltip_honor" />
    <anchored to="comeliness" position="below" offset="0,5" height="36"/>
    <target>honor</target>
</number_honor>
```

**Key Points:**
- `position="below"` places element directly under the target
- `to="previous_element"` specifies which element to stack under
- `offset="0,5"` adds vertical gap (x=0, y=5)
- Creates a vertical chain: charisma → comeliness → honor


---

### Responsive Fill (Expand to Container)

**Problem:** Make a control expand to fill the available horizontal space between two anchor points.

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
- `<top parent="columnanchor" anchor="bottom" relation="relative" />` positions below an anchor
- `<datasource>.resources</datasource>` binds to database node
- `<class>resource_item</class>` defines template for each row
- `<columns width="192" fillwidth="true" />` sets row width behavior
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
	...
</label_charframetop>
```

**Key Points:**
- `<anchor_column>` is a predefined FGU template for column flow
- Elements use `<top parent="columnanchor" anchor="bottom" relation="relative" />`
- This means "position my top at the bottom of the previous element"
- Creates automatic vertical stacking without explicit `position="below"`


---

### Positioning from Right Edge

**Problem:** Position a control relative to the right edge of its container (e.g., delete buttons).

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

### Fixed vs Responsive Sizing (When to Use Each)

**Problem:** Deciding whether to use fixed pixel dimensions (`width="280"`) or responsive anchoring (`<left>` + `<right>`).

**Research Date:** 2026-01-26

**Evidence from references:**

Quantitative analysis of reference extensions:
- Fixed `width="N" height="N"` patterns: **85 occurrences** across 12 files
- Responsive `<left>...<right>` patterns: **20 occurrences** across 20 files

Both patterns are widely used - the question is **when** each is appropriate.

**Pattern: Fixed Sizing is Appropriate For:**

Source: `references/FG-2e-PlayersOption/campaign/record_char_main.xml` (lines 111-149)

```xml
<buttoncontrol name="remove_fatigue_button" insertafter="specialdef">
    <anchored to="contentanchor" width="20" height="30">
        <top parent="combatanchor" anchor="bottom" relation="relative" offset="20" />
        <left offset="-20"/>
    </anchored>
    <icon normal="button_page_prev" />
</buttoncontrol>

<number_fatigue_charsheet name="current_fatigue" source="fatigue.score">
    <anchored to="contentanchor" width="40" height="30">
        <top parent="remove_fatigue_button" anchor="top" relation="relative" offset="0" />
        <left parent="remove_fatigue_button" anchor="right" relation="relative" />
    </anchored>
</number_fatigue_charsheet>
```

| Element Type | Use Fixed? | Reason |
|--------------|------------|--------|
| Buttons, icons | Yes | Icon size is constant |
| Number fields (1-3 digits) | Yes | Content length is predictable |
| Abbreviation labels ("STR", "DEX") | Yes | Short, known text |
| Checkboxes | Yes | Standard size |

**Pattern: Responsive Sizing is Appropriate For:**

Source: `references/CapitalGains/campaign/record_resource.xml` (lines 66-72, 396-401)

```xml
<!-- Name field fills available space -->
<stringu name="name">
    <anchored height="20">
        <top offset="5" />
        <left parent="leftanchor" anchor="right" relation="relative" offset="5" />
        <right parent="rightanchor" anchor="left" relation="relative" offset="0" />
    </anchored>
</stringu>

<!-- String control expands to fill row -->
<stringcontrol name="name">
    <anchored height="20">
        <left parent="shortcut" anchor="right" offset="5" />
        <top />
        <right />
    </anchored>
</stringcontrol>
```

| Element Type | Use Responsive? | Reason |
|--------------|-----------------|--------|
| Name/title fields | Yes | Content varies in length |
| Description/notes | Yes | User-entered text varies |
| Lists (windowlist) | Yes | Should fill available space |
| Top-level content areas | Yes | Adapt to window size |

**Pattern: Hybrid (Fixed Width, Responsive Position)**

Source: `references/FG-CoreRPG-Moon-Tracker/utility/utility_moon.xml` (lines 114-118)

```xml
<number_moon name="shift">
    <anchored width="45" height="20">
        <top offset="2" />
        <right parent="rightanchor" anchor="left" relation="relative" offset="-10" />
    </anchored>
</number_moon>
```

Use this pattern when:
- Control has fixed size (number field = 45px wide)
- But should stay pinned to right edge as container resizes
- Combines `width="45"` with responsive right-edge anchoring

**Window-Level Size Limits:**

Source: `references/CapitalGains/campaign/record_resource.xml` (lines 79-84)

```xml
<placement>
    <size width="350" height="350" />
</placement>
<sizelimits>
    <minimum width="300" height="300" />
    <dynamic />
</sizelimits>
```

Source: `references/FGU-Theme-Hearth/rulesets/corerpg_compilation.xml` (lines 1025-1028)

```xml
<sizelimits>
    <minimum width="525" height="625" />
    <dynamic />
</sizelimits>
```

**Key Points:**
- `<placement><size>` sets default window size
- `<sizelimits><minimum>` prevents shrinking below content needs
- `<dynamic />` allows user to resize the window larger
- Without `<dynamic />`, window has fixed size

**Decision Matrix:**

| Content Type | Pattern | Example |
|--------------|---------|---------|
| Button/icon | Fixed `width`+`height` | `width="20" height="20"` |
| Number field | Fixed `width`, fixed `height` | `width="40" height="20"` |
| Short label | Fixed `width` | `width="60"` |
| Text input | Responsive `<left>`+`<right>` | See stringu example |
| Container frame | Fixed if internal layout is fixed | `width="280" height="220"` |
| Windowlist | Responsive | `<left offset="6" /><right offset="3" />` |
| Side-by-side frames | Consider hybrid or anchoring | Anchor second frame to first |

**Common Mistake: Fixed Offset for Adjacent Frames**

Problem code:
```xml
<frame_char name="physical_frame">
    <anchored position="insidetopleft" offset="0,0" width="280" height="220" />
</frame_char>
<frame_char name="mental_frame">
    <anchored position="insidetopleft" offset="300,0" width="280" height="220" />
</frame_char>
```

Issue: If window is narrower than 580px, `mental_frame` gets clipped.

Better approach - anchor second frame to first:
```xml
<frame_char name="physical_frame">
    <anchored position="insidetopleft" offset="0,0" width="280" height="220" />
</frame_char>
<frame_char name="mental_frame">
    <anchored to="physical_frame" position="righthigh" offset="20,0" width="280" height="220" />
</frame_char>
```

Or use minimum window size to guarantee space:
```xml
<sizelimits>
    <minimum width="600" height="400" />
</sizelimits>
```

