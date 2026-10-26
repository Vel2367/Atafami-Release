--!strict
--!nolint DeprecatedApi
-- Standalone executor foundation. No other UI is loaded or required.
-- ContentRoot hosts shared adaptive sections and control views. OverlayRoot
-- hosts popups outside content clipping. ControlValues owns values separately
-- from Geometry/Life; CFG persists values without retaining interaction state.

export type IconCapabilities = {
	Request: (({ Url: string, Method: string, Headers: { [string]: string } }) -> any)?,
	IsFile: ((string) -> boolean)?, ReadFile: ((string) -> string)?,
	WriteFile: ((string, string) -> ())?, GetAsset: ((string) -> string)?,
	IsFolder: ((string) -> boolean)?, MakeFolder: ((string) -> ())?,
	ListFiles: ((string) -> { string })?,
}
export type ConfigCapabilities = {
	IsFile: ((string) -> boolean)?, ReadFile: ((string) -> string)?, WriteFile: ((string, string) -> ())?,
	IsFolder: ((string) -> boolean)?, MakeFolder: ((string) -> ())?, ListFiles: ((string) -> { string })?, DeleteFile: ((string) -> ())?,
}
export type ConfigProvider = {
	List: () -> { string }, GetActive: () -> string?, Load: (string) -> (), Save: (string) -> (), Delete: (string) -> (),
}
export type ConfigLoadReport = { Applied: number, Skipped: number, Errors: { string } }
export type KeybindFlag = { Type: "KeyCode" | "UserInputType", Name: string }
export type ColorFlag = { R: number, G: number, B: number }
export type FlagValue = boolean | number | string | { string } | KeybindFlag | ColorFlag
export type TabOptions = {
	Id: string, Name: string, Icon: string, Active: boolean?,
	Callback: ((boolean, string) -> ())?,
}
export type ToggleOptions = { Id: string, Name: string, Flag: string?, Default: boolean, Callback: ((boolean, string) -> ())? }
export type ToggleSetOptions = ValueSetOptions
export type DropdownOptions = { Id: string, Name: string, Flag: string?, Values: { string }, Default: string?, Callback: ((string, string) -> ())? }
export type MultiDropdownOptions = { Id: string, Name: string, Flag: string?, Values: { string }, Default: { string }?, Callback: (({ string }, string) -> ())? }
-- Zero results remain valid; only the first returned string is displayed.
export type ButtonCallback = () -> ...string?
export type ButtonOptions = { Id: string, Name: string, Callback: ButtonCallback?, Repeatable: boolean?, Disabled: boolean?, Icon: string? }
export type SliderOptions = { Id: string, Name: string, Flag: string?, Min: number, Max: number, Step: number, Default: number, Callback: ((number, string) -> ())? }
export type ColorPickerOptions = { Id: string, Name: string, Flag: string?, Default: Color3, Callback: ((Color3, string) -> ())? }
export type KeybindOptions = { Id: string, Name: string, Flag: string?, Default: EnumItem?, Callback: ((EnumItem?, string) -> ())? }
export type ValueSetOptions = { Emit: boolean?, Replay: boolean? }
export type SectionOptions = { Id: string, Name: string, Collapsed: boolean? }
export type TabBehavior = { Active: boolean?, Callback: ((boolean, string) -> ())? }
export type Options = {
	Parent: Instance?, Size: Vector2?, Position: Vector2?, Visible: boolean?,
	BootstrapTimeout: number?, IconTimeout: number?, IconCapabilities: IconCapabilities?, ConfigCapabilities: ConfigCapabilities?, Tabs: { TabOptions }?, Search: TabBehavior?, Settings: TabBehavior?,
	ConfigProvider: ConfigProvider?, ConfigTransform: ((any) -> any)?,
	MenuKeybind: EnumItem?, AnimationsEnabled: boolean?, OnReload: ((ReloadState) -> App)?, OnUnload: (() -> ())?, OnDiscord: (() -> ())?,
	BackgroundFile: string?, BackgroundDim: number?, BackgroundColor: Color3?, AccentColor: Color3?, ScriptVersion: string?,
}
-- An owner rebuilds its declarations, not its loader or gameplay resources.
-- The snapshot contains values/layout only; it never retains the old GUI.
export type ReloadState = {
	MenuKeybind: EnumItem?, AnimationsEnabled: boolean, Visible: boolean, Position: Vector2, Size: Vector2,
	Tabs: { [string]: boolean }, Values: { [string]: { Kind: string, Value: any, Values: { string }? } }, Buttons: { [string]: boolean },
	CompletedButtons: { [string]: boolean }?,
	Sections: { [string]: boolean }, Order: { string }, Reordered: boolean,
	Minis: { [string]: { Position: UDim2, Scroll: Vector2 } }, OpenMinis: { string },
	ContentScroll: Vector2, SettingsScroll: Vector2, TabScroll: Vector2, Query: string, SearchCollapsed: { [string]: boolean },
	SearchEditing: boolean,
	SearchSavedScroll: Vector2?, SearchRestoreScroll: Vector2?,
}

-- Appearance and stacking: every GuiObject uses one named layer.
local Appearance = table.freeze({
	Background = Color3.fromRGB(13, 13, 13), Panel = Color3.fromRGB(24, 24, 24),
	Outline = Color3.fromRGB(79, 79, 79), Divider = Color3.fromRGB(57, 57, 57),
	Button = Color3.fromRGB(31, 31, 31), HoverButton = Color3.fromRGB(43, 43, 43),
	ToggleOff = Color3.fromRGB(72, 72, 72),
	ToggleThumb = Color3.fromRGB(235, 235, 235), ToggleWidth = 30, ToggleHeight = 16, ToggleInset = 2, ToggleRow = 24,
	White = Color3.fromRGB(230, 230, 230), IdleIcon = Color3.fromRGB(181, 181, 181),
	Radius = 8, PanelHeight = 42, FooterHeight = math.round(42 / 2.5), SearchHeight = 40, ButtonSize = 32, IconSize = 26, ButtonGap = 8,
	TabActiveIcon = Color3.fromRGB(240, 240, 240),
	TabHoverScale = 1.06, TabTweenTime = 0.14, TabDividerSlot = 6,
	SectionHeader = 30, SectionPadding = 10, SectionIconSize = 22.08, SectionCollapseIconSize = 23.04 * 0.85,
	SettingsSectionIconSize = 22.08 * 0.85, SettingsDimTransparency = 0.12,
	SectionDragIconSize = 17.28 * 0.85, SectionIconCenter = Vector2.new(16, 15), SectionTitleSize = 13,
	SectionTextStart = 34, SectionTabMaxWidth = 68, SectionTitleGap = 8, SectionDividerHeight = 14,
	ContentPadding = 12, ContentRightPadding = 6, ContentGap = 12, CardWidth = 260, Scrollbar = 0,
	Field = Color3.fromRGB(30, 30, 30), FieldOutline = Color3.fromRGB(58, 58, 58), Value = Color3.fromRGB(218, 218, 218),
	Selected = Color3.fromRGB(39, 39, 39), DropdownWidth = 106, ControlHeight = 24, PopupInset = 4, OptionHeight = 26,
	Card = Color3.fromRGB(24, 24, 24), CardOutline = Color3.fromRGB(54, 54, 54), MutedText = Color3.fromRGB(148, 148, 148),
	Minimum = Vector2.new(278, 180), Initial = Vector2.new(392, 224), Margin = 12,
})
local REGULAR_FACE = Font.new("rbxasset://fonts/families/JosefinSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local Layers = table.freeze({
	Background = 10, Decoration = 11, Content = 20, Settings = 25, SettingsContent = 26, Search = 27, Panel = 30, Resize = 40,
	SectionDrag = 45, MiniSection = 48, Popup = 50, Tooltip = 60, Modal = 70, Loading = 100,
})
local DISPLAY_ORDER = 80
local Paths = table.freeze({ Root = "atafami", UI = "atafami/ui_cache", Icons = "atafami/ui_cache/Icon", Background = "atafami/ui_cache/Menu", Configs = "atafami/configs" })
local ICON_BASE = "https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/assets/icons/"
local DEFAULT_BACKGROUND = "halloween.jpg"
local ResizeStyle = table.freeze({ Gutter = 8, Gap = 3, Hit = 36, Idle = 16, Thickness = 3 })
local SECTION_DRAG_ICON = "fa--arrows.png"
local SECTION_COLLAPSE_ICON = "iconmind--chevrons-up-down-outline-bold.png"
local DROPDOWN_ICON = "dashicons--arrow-up-alt2.png"
local BUTTON_ACTION_ICON = "icon-park-solid--click.png"
local DISCORD_ICON = "akar-icons--discord-fill.png"
local MINI_GEAR_ICON = "gravity-ui--gear.png"
local PickerStyle = table.freeze({ Width=132, Height=188, DragHeight=16, Padding=6, SwatchSize=18 })
local MiniStyle = table.freeze({ Width=255, GearWidth=20, GearGap=4, Icon=14*1.05*1.05, Header=16, HitHeight=22, Padding=10, ContentInset=5, Margin=8, Gap=7 })
local INSTANCE_SLOT = "__AtafamiScriptUIFoundation_v1"
local RELOAD_SLOT = "__AtafamiScriptUIReload_v1"
local CURSOR_SLOT = "__AtafamiDefoltCursorBridge_v1"

type Scope = { Closed: boolean, Cleanup: { () -> () }, Tasks: { [thread]: boolean } }
type ReloadGate = { Scope: Scope, Thread: thread, Candidate: App?, Pending: boolean, Cancelled: boolean, Deadline: number }
type Life = {
	Phase: string, Error: string?, Visible: boolean, RequestedVisible: boolean,
	Completed: number, Stage: string, Deadline: number, Timeout: number, IconTimeout: number,
}
type Geometry = {
	Position: Vector2, Size: Vector2, Viewport: Vector2, Initialized: boolean,
}
type Gesture = { Kind: string, Pointer: InputObject, Origin: Vector2, Position: Vector2, Size: Vector2 }
type InputState = { Gesture: Gesture?, Scope: Scope, ResizeHovered: boolean }
type Capture = {
	Active: boolean, Scope: Scope?, Mouse: Enum.MouseBehavior?, Icon: boolean?, Sensitivity: number?, Writing: boolean,
	RenderAfter: string, Action: string, Bridge: any,
}
type IconStats = { DiskHits: number, MemoryHits: number, WorkerStarts: number, NetworkRequests: number, CorruptCache: number, Failures: number, Pending: number }
type IconJob = { Scope: Scope, Deadline: number, Consumers: number, Done: boolean, Asset: string?, Outcome: string }
type IconState = { Stats: IconStats, Scope: Scope, Cache: { [string]: string }, Jobs: { [string]: IconJob }, DropdownAsset: string?, DropdownOutcome: string, DropdownStarted: boolean, ButtonAssets: { [string]: string }, GearAsset: string?, GearOutcome: string, GearStarted: boolean }
type BackgroundState = {
	Scope: Scope, Work: Scope?, Root: CanvasGroup?, Image: ImageLabel?, Shade: Frame?,
	Selection: { Scope: Scope, Model: DropdownModel, Handle: any }?,
	Dimming: { Scope: Scope, Model: SliderModel, Handle: any }?, File: string?, Dim: number,
	Accent: { Scope: Scope, Model: ColorModel, Handle: any }?, Color: Color3,
	Revision: number, Outcome: string, Stats: IconStats,
}
type TabRecord = {
	Metadata: { Id: string, Name: string, Icon: string }, Active: boolean, Hovered: boolean, TitleWidth: number,
	Callback: ((boolean, string) -> ())?, Scope: Scope,
	Button: ImageButton?, Image: ImageLabel?, Indicator: Frame?, Fallback: Frame?, Asset: string?, Outcome: string,
	Visual: Frame?, PaintScope: Scope?, GoalScale: number?,
	Pressed: boolean, Returning: boolean,
	Handle: TabHandle?, Owner: App,
}
type HostMetadata = { Id: string, Name: string, TabId: string, Path: string, SectionId: string?, ParentControlId: string?, ParentControlPath: string? }
type ControlMetadata = { Id: string, Name: string, Flag: string?, TabId: string, SectionId: string, Path: string, ParentControlId: string?, ParentControlPath: string? }
type SectionRecord = {
	Kind: "Section",
	Metadata: HostMetadata, Collapsed: boolean, Destroying: boolean, Owner: App, Tab: TabRecord,
	Scope: Scope, Root: Frame?, Header: Frame?, TitleButton: TextButton?, Body: Frame?, ContentLayout: UIListLayout?,
	TabIcon: ImageLabel?, TabLabel: TextLabel?, Separator: Frame?, NameLabel: TextLabel?, Chevron: ImageLabel?,
	DragHandle: ImageButton?, DragIcon: ImageLabel?, CollapseHandle: TextButton?,
	Position: Vector2, Size: Vector2, Column: number, NextControlOrder: number, Handle: SectionHandle?,
	RevealPending: boolean, ExitPending: boolean, HeightPending: boolean,
}
type SectionCollection = { Order: { SectionRecord }, ById: { [string]: SectionRecord } }
type SectionSlot = { Record: SectionRecord, Column: number, Position: Vector2, Size: Vector2 }
type SectionDrag = {
	Record: SectionRecord, Pointer: InputObject, Scope: Scope, Placeholder: Frame,
	SourceOrder: { SectionRecord }, PreviewOrder: { SectionRecord }, Offset: Vector2, Point: Vector2,
	PendingIndex: number?, Valid: boolean,
}
type SectionArea = {
	Scope: Scope, ByTab: { [string]: SectionCollection }, Order: { SectionRecord }, Reordered: boolean, Queued: boolean,
	Columns: number, CardWidth: number, CanvasHeight: number, Drag: SectionDrag?,
	DragAsset: string?, CollapseAsset: string?, DragIconOutcome: string, CollapseIconOutcome: string, HeaderIconsStarted: boolean,
}
type TabCollection = { Order: { TabRecord }, ById: { [string]: TabRecord }, Search: TabRecord?, Settings: TabRecord? }
-- Only derived visibility is cached here; metadata and values remain in their
-- existing owners. Utility activation still belongs to TabRecord.
type SearchState = {
	Query: string, Editing: boolean, Dirty: boolean, Revision: number,
	SavedScroll: Vector2?, RestoreScroll: Vector2?,
	Sections: { [string]: boolean }, Controls: { [string]: boolean }, Collapsed: { [string]: boolean },
	SectionCount: number, ControlCount: number,
}
export type SearchStatus = { Active: boolean, Editing: boolean, Query: string, SectionCount: number, ControlCount: number }
type SettingsArea = { Columns: number, CanvasHeight: number }
type ConfigState = {
	Capabilities: ConfigCapabilities, Scope: Scope?, Section: SectionRecord?, Root: Frame?, Name: TextBox?, Arrow: TextButton?,
	Chevron: ImageLabel?, Buttons: { [string]: TextButton }, Popup: ScrollingFrame?, PopupScope: Scope?,
	Names: { string }, Busy: boolean, Ready: boolean, Active: string?, Selected: string?, Provider: ConfigProvider?, Transform: ((any) -> any)?,
	Confirmation: { Action: string, Name: string, Deadline: number, Scope: Scope }?,
	ButtonStates: { [string]: { Hovered: boolean, Pressed: boolean, Flashing: boolean, Feedback: Scope? } },
}
type Preferences = {
	InitialKey: EnumItem?, InitialAnimations: boolean, MenuBinding: KeybindRecord?, Animations: ToggleRecord?,
	AccentColor: Color3, Accent: { Scope: Scope, Model: ColorModel, Handle: any }?,
	ScriptVersion: string?,
	OnReload: ((ReloadState) -> App)?, OnUnload: (() -> ())?, Unloading: boolean,
	Restoring: boolean,
}
type MotionTrack = { Scope: Scope, Object: any, Goals: { [string]: any } }
type MotionState = {
	Scope: Scope, Menu: Scope?, Sections: Scope?, Next: string?, FinishLayout: boolean, Target: string,
	Presented: { [string]: boolean }, Tracks: { [Instance]: MotionTrack }, Closing: { [string]: { Scope: Scope, Path: string } },
	Alphas: { [Instance]: { [string]: AlphaTarget } },
}
-- Serializable state has no GUI, callbacks, scopes or transient interaction data.
type ToggleModel = { Kind: "Toggle", Metadata: ControlMetadata, Default: boolean, Value: boolean }
type DropdownModel = { Kind: "Dropdown", Metadata: ControlMetadata, Default: string, Value: string, Values: { string } }
type MultiDropdownModel = { Kind: "MultiDropdown", Metadata: ControlMetadata, Default: { string }, Value: { string }, Values: { string } }
type KeybindModel = { Kind: "Keybind", Metadata: ControlMetadata, Default: EnumItem?, Value: EnumItem? }
type ColorModel = { Kind: "ColorPicker", Metadata: ControlMetadata, Default: Color3, Value: Color3 }
type SliderModel = { Kind: "Slider", Metadata: ControlMetadata, Default: number, Value: number, Minimum: number, Maximum: number, Step: number, Precision: number }
type ControlModel = ToggleModel | DropdownModel | MultiDropdownModel | KeybindModel | ColorModel | SliderModel
type ToggleGui = { Row: TextButton?, Label: TextLabel?, Track: Frame?, Thumb: Frame? }
type FieldGui = { Row: Frame?, Label: TextLabel?, Field: TextButton?, ValueLabel: TextLabel?, Chevron: ImageLabel?, Icon: ImageLabel? }
type SliderGui = { Row: Frame?, Label: TextLabel?, Field: TextBox?, Track: Frame?, Fill: Frame?, Thumb: Frame?, Hit: TextButton? }
type SelectTextState = { Cache: { [string]: Vector2 }, Count: number, Font: Font?, Size: number?, Summary: Scope?, Candidate: string?, Available: number?, SummaryWidth: number? }
type ToggleRecord = {
	Kind: "Toggle",
	Metadata: ControlMetadata, Model: ToggleModel, Callback: ((boolean, string) -> ())?,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: ToggleGui, Handle: ToggleHandle?,
}
type DropdownRecord = {
	Kind: "Dropdown", Metadata: ControlMetadata, Model: DropdownModel, Callback: ((string, string) -> ())?,
	Text: SelectTextState,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: FieldGui, Handle: DropdownHandle?,
}
type KeybindRecord = {
	Kind: "Keybind", Metadata: ControlMetadata, Model: KeybindModel, Callback: ((EnumItem?, string) -> ())?,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: FieldGui, CapturedInput: InputObject?, Handle: KeybindHandle?,
}
type MultiDropdownRecord = {
	Kind: "MultiDropdown", Metadata: ControlMetadata, Model: MultiDropdownModel, Callback: (({ string }, string) -> ())?,
	Text: SelectTextState,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: FieldGui, Handle: MultiDropdownHandle?,
}
type ButtonRecord = {
	Kind: "Button", Metadata: ControlMetadata, Callback: ButtonCallback?, Disabled: boolean, Hovered: boolean, Pressed: boolean,
	Repeatable: boolean, Completed: boolean, Busy: boolean, Inline: boolean, Revision: number, Flashing: boolean, Status: string?, Run: Scope?, Feedback: Scope?,
	IconSource: string, IconOutcome: string,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: FieldGui, Handle: ButtonHandle?,
}
type MiniRecord = {
	Kind: "MiniSection", Metadata: HostMetadata, Owner: App, Tab: TabRecord, OwnerControl: ControlView, Parent: MiniRecord?, RootSection: SectionRecord,
	Scope: Scope, Open: boolean, Depth: number, Destroying: boolean, ReservedLabel: boolean, Root: Frame?, Body: Frame?, Scroll: ScrollingFrame?, ContentLayout: UIListLayout?, NextControlOrder: number,
	Gear: ImageButton?, GearImage: ImageLabel?, DragHandle: TextButton?, Handle: MiniHandle?,
}
type ControlHost = SectionRecord | MiniRecord
type MiniState = { Scope: Scope, Order: { MiniRecord }, ByControl: { [string]: MiniRecord }, Chain: { MiniRecord } }
type ColorRecord = {
	Kind: "ColorPicker", Metadata: ControlMetadata, Model: ColorModel, Hue: number, Saturation: number, Brightness: number, Callback: ((Color3, string) -> ())?,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: FieldGui, Handle: ColorPickerHandle?,
}
type SliderRecord = {
	Kind: "Slider", Metadata: ControlMetadata, Model: SliderModel, Callback: ((number, string) -> ())?,
	Scope: Scope, Owner: App, Section: ControlHost, Gui: SliderGui, Handle: SliderHandle?,
}
type SurfaceGesture = {
	Kind: "SV" | "Hue" | "ColorDrag" | "MiniDrag" | "Slider", Pointer: InputObject, Origin: Vector2, Position: Vector2,
	Color: ColorRecord?, Mini: MiniRecord?, Slider: SliderRecord?,
}
type ColorPopup = { Scope: Scope, Record: ColorRecord, Root: Frame, SV: Frame, Hue: Frame, Cursor: Frame, HueCursor: Frame, Preview: Frame, Hex: TextBox, RGB: {TextBox}, DragHandle: TextButton, ManualPosition: Vector2? }
type SelectRecord = DropdownRecord | MultiDropdownRecord
type ControlRecord = ToggleRecord | DropdownRecord | MultiDropdownRecord | KeybindRecord | ColorRecord | SliderRecord
type ControlView = ControlRecord | ButtonRecord
type ActionCollection = { Order: { ButtonRecord }, ById: { [string]: ButtonRecord } }
type ButtonActions = { Scope: Scope, ByPath: { [string]: ButtonRecord }, BySection: { [string]: ActionCollection } }
type ControlCollection = { Order: { ControlRecord }, ById: { [string]: ControlRecord } }
-- The extra index is a lookup port; retaining another recursive record graph
-- here would expand every public App method in Luau's structural solver.
type ControlValues = { Scope: Scope, ByPath: { [string]: ControlModel }, ByFlag: { [string]: any }, BySection: { [string]: ControlCollection } }
type DropdownOptionView = { Value: string, Button: TextButton, Label: TextLabel, Height: number }
type DropdownPopup = { Scope: Scope, Record: SelectRecord, Root: ScrollingFrame, Options: { DropdownOptionView }, Hovered: TextButton?, Closing: boolean, FadeScope: Scope?, Alpha: (() -> number)?, Measurement: Scope?, MeasureWidth: number?, TextWidth: number?, Choices: { string } }
type ControlInteraction = { Popup: DropdownPopup?, Color: ColorPopup?, Surface: SurfaceGesture?, Editor: SliderRecord?, Assignment: KeybindRecord?, ConsumedPointer: InputObject? }
type Environment = {
	Globals: { [string]: any }, Capabilities: IconCapabilities,
	Input: UserInputService, Run: RunService, Players: Players, Actions: ContextActionService,
	Content: ContentProvider, Player: Player?,
}
type View = {
	SettingsLayer: TextButton?, SettingsContent: ScrollingFrame?, SearchLayer: Frame?, SearchInput: TextBox?,
	MiniLayer: Frame?, Screen: ScreenGui?, Canvas: Frame?, Root: Frame?, Content: ScrollingFrame?, Overlay: Frame?,
	Panel: Frame?, TabStrip: ScrollingFrame?, TabGroup: Frame?, TabDivider: Frame?, TabDividerSlot: Frame?,
	Footer: Frame?, FooterText: TextLabel?,
	Grip: TextButton?, ResizeVisual: Frame?, ResizeStroke: UIStroke?, ResizeCaps: { Frame }?, Loading: Frame?, Progress: Frame?,
}
export type App = {
	_metrics: { TextMeasurements: number, LayoutPasses: number, SearchPasses: number, PopupPaintWrites: number },
	_search: SearchState, _settings: SettingsArea, _configs: ConfigState,
	_preferences: Preferences, _motion: MotionState,
	_life: Life, _geometry: Geometry, _input: InputState, _capture: Capture,
	_icons: IconState, _background: BackgroundState, _values: ControlValues, _buttons: ButtonActions, _minis: MiniState, _interaction: ControlInteraction, _tabs: TabCollection, _sections: SectionArea, _env: Environment, _view: View, _scope: Scope, _boot: Scope,
	ScreenGui: ScreenGui?, Root: Frame?, ContentRoot: ScrollingFrame?, OverlayRoot: Frame?,
	Panel: Frame?, TabStrip: ScrollingFrame?, ResizeHandle: TextButton?,

	Destroy: (App) -> (), IsDestroyed: (App) -> boolean,
	SetVisible: (App, boolean) -> (), IsVisible: (App) -> boolean,
	SetGeometry: (App, Vector2, Vector2) -> (), GetGeometry: (App) -> { Position: Vector2, Size: Vector2, Viewport: Vector2 },
	AddTab: (App, TabOptions) -> TabHandle, GetTab: (App, string) -> TabHandle?,
	GetContentLayout: (App) -> ContentStatus, GetStatus: (App) -> AppStatus, GetIconStats: (App) -> IconStats,
	GetBackgroundStats: (App) -> IconStats,
	ListBackgrounds: (App) -> { string }, RefreshBackgrounds: (App) -> { string },
	GetBackground: (App) -> string?, SetBackground: (App, string?) -> (),
	GetBackgroundDim: (App) -> number, SetBackgroundDim: (App, number) -> (),
	GetBackgroundColor: (App) -> Color3, SetBackgroundColor: (App, Color3) -> (),
	GetAccentColor: (App) -> Color3, SetAccentColor: (App, Color3) -> (),
	GetBackgroundStatus: (App) -> { File: string?, Dim: number, Outcome: string },
	GetSearchStatus: (App) -> SearchStatus, GetSearchInput: (App) -> TextBox?,
	GetSettingsContent: (App) -> ScrollingFrame?, GetSettingsLayout: (App) -> ContentStatus,
	GetMenuKeybind: (App) -> EnumItem?, SetMenuKeybind: (App, EnumItem?) -> (),
	GetAnimationsEnabled: (App) -> boolean, SetAnimationsEnabled: (App, boolean) -> (),
	ListConfigs: (App) -> { string }, GetActiveConfig: (App) -> string?, SaveConfig: (App, string) -> (),
	LoadConfig: (App, string, ValueSetOptions?) -> ConfigLoadReport?, DeleteConfig: (App, string) -> (),
	ExportConfig: (App) -> any, ApplyConfig: (App, any, ValueSetOptions?) -> ConfigLoadReport,
	HasFlag: (App, string) -> boolean, GetFlag: (App, string) -> FlagValue?,
	SetFlag: (App, string, FlagValue?, ValueSetOptions?) -> (), ResetFlag: (App, string) -> (), GetFlags: (App) -> { [string]: FlagValue },
	Reload: (App) -> App?, Unload: (App) -> (),
	_dispose: (App) -> (), _fail: (App, string) -> (),
}
-- Explicit component ports keep mutually recursive calls bounded in Luau.
type ResourcesComponent = {
	add: (owner: Scope, dispose: () -> ()) -> () -> (),
	own: (parent: Scope, child: Scope, dispose: (() -> ())?) -> (),
	close: (owner: Scope) -> (),
	spawn: (owner: Scope, callback: () -> ()) -> thread?,
	connect: (owner: Scope, signal: RBXScriptSignal, callback: (...any) -> ()) -> (),
	tween: (owner: Scope, tween: Tween) -> (),
}
type RuntimeComponent = {
	discover: (provided: IconCapabilities?) -> Environment,
	parent: (app: App, requested: Instance?) -> Instance,
	prepare: (app: App) -> (),
}
type IconsComponent = {
	source: (spec: string) -> string,
	path: (spec: string) -> string,
	resolve: (app: App, source: string, current: () -> boolean) -> (string?, string),
	load: (app: App, source: string, owner: Scope, label: string) -> (string?, string),
}
type BackgroundComponent = {
	build: (App) -> (), start: (App) -> (), visible: (App) -> (), path: (string) -> string,
	list: (App) -> { string }, refresh: (App) -> { string }, request: (App) -> (),
	paint: (App) -> (), select: (App) -> (), valid: (string, string) -> boolean,
}
type GuiComponent = {
	chrome: (app: App, surface: Frame, top: number, bottom: number) -> (), footer: (app: App) -> (),
	shell: (app: App, parent: Instance) -> (),
	build: (app: App) -> (),
	showing: (app: App) -> boolean, sync: (app: App) -> (),
}
type LayoutComponent = {
	viewport: (app: App) -> Vector2,
	margin: (viewport: Vector2) -> number,
	apply: (app: App) -> (),
}
type TabsComponent = {
	validate: (options: TabOptions) -> (),
	paint: (record: TabRecord, instant: boolean?) -> (),
	press: (record: TabRecord) -> (),
	clearHover: (app: App) -> (),
	arrange: (app: App) -> (),
	mount: (app: App, record: TabRecord) -> (),
	load: (app: App, record: TabRecord) -> (),
}
type SectionsComponent = {
	request: (app: App) -> (),
	refreshIcons: (app: App) -> (),
	loadHeaderIcons: (app: App) -> (),
	visibility: (app: App, tab: TabRecord) -> (),
	registrationOrder: (app: App) -> { SectionRecord },
	ordered: (app: App, settings: boolean?) -> { SectionRecord },
	container: (app: App, tab: TabRecord?) -> ScrollingFrame?,
	participates: (record: SectionRecord) -> boolean,
	interactive: (record: SectionRecord) -> boolean,
	plan: (app: App, ordered: { SectionRecord }, scroll: ScrollingFrame?) -> ({ SectionSlot }, number, number),
	render: (app: App, slots: { SectionSlot }, drag: SectionDrag?) -> (),
	reflow: (app: App) -> (),
	moveDrag: (app: App, point: Vector2) -> (),
	endDrag: (app: App, commit: boolean) -> (),
	cancelDrag: (app: App) -> (),
	beginDrag: (app: App, record: SectionRecord, event: InputObject) -> (),
	build: (app: App, record: SectionRecord) -> (),
}
type ModesComponent = {
	build: (app: App) -> (), paint: (app: App) -> (), focus: (app: App) -> (),
	filtering: (app: App) -> boolean, settingsOpen: (app: App) -> boolean,
	collapsed: (record: SectionRecord) -> boolean,
	invalidate: (app: App) -> (), refresh: (app: App) -> (), query: (app: App, query: string) -> (),
	matchHost: (app: App, path: string, inherited: boolean, query: string) -> boolean,
	rows: (app: App, path: string, filtered: boolean) -> (),
	search: (app: App, active: boolean) -> (), settings: (app: App, active: boolean) -> (),
	finishSearch: (app: App) -> (), releaseSearch: (app: App) -> (), cancel: (app: App) -> (),
	restore: (app: App) -> (),
}
type ControlsComponent = {
	available: (record: ControlView) -> boolean,
	emit: (record: ControlRecord, value: any, options: ValueSetOptions?) -> (),
	paint: (record: ToggleRecord, instant: boolean?) -> (),
	destroySection: (section: ControlHost) -> (),
	build: (record: ToggleRecord, order: number) -> (),
	options: (options: ValueSetOptions?) -> (),
	interactive: (record: ControlView) -> boolean,
	contains: (object: GuiObject?, at: Vector2) -> boolean,
	closePopup: (app: App, instant: boolean?) -> (),
	cancelAssignment: (app: App) -> (),
	cancel: (app: App, section: ControlHost?) -> (),
	remove: (record: ControlView) -> (),
	register: (section: ControlHost, record: ControlView) -> number,
	clear: (record: ControlView) -> (),
	mount: (record: ControlView, prototype: any, build: (number) -> ()) -> any,
	metadata: (section: ControlHost, options: { Id: string, Name: string, Flag: string? }) -> ControlMetadata,
	text: (record: SelectRecord | KeybindRecord | ColorRecord | ButtonRecord, parent: Instance, name: string, text: string, size: number) -> TextLabel,
	field: (record: SelectRecord | KeybindRecord | ColorRecord | ButtonRecord, order: number, width: number, height: number) -> (),
	validateValues: (values: { string }) -> { string },
	paintPopup: (popup: DropdownPopup) -> (),
	paintDropdown: (record: SelectRecord) -> (),
	fieldAccent: (record: SelectRecord | KeybindRecord) -> (),
	measureBounds: (record: SelectRecord, owner: Scope, text: string, width: number, font: Font, size: number) -> Vector2?,
	measureSummary: (record: SelectRecord) -> (),
	measurePopup: (popup: DropdownPopup, width: number) -> (),
	placePopup: (popup: DropdownPopup) -> (),
	openDropdown: (record: SelectRecord) -> (),
	buildDropdown: (record: SelectRecord, order: number) -> (),
	multiValues: (values: { string }) -> { string },
	selection: (values: { string }, input: { string }) -> { string },
	sameArray: (left: { string }, right: { string }) -> boolean,
	paintButton: (record: ButtonRecord) -> (),
	actionSurface: (App, TextButton, boolean, boolean, boolean, boolean) -> (),
	flash: (Scope, () -> ()) -> (),
	pressButton: (record: ButtonRecord) -> boolean,
	addButton: (section: ControlHost, options: ButtonOptions, inline: boolean?) -> ButtonHandle,
	validKey: (value: EnumItem?) -> boolean,
	paintKeybind: (record: KeybindRecord) -> (),
	input: (app: App, event: InputObject) -> boolean,
	loadDropdownIcon: (app: App) -> (),
	loadButtonIcon: (app: App) -> (),
	layout: (host: ControlHost) -> (),
}
type MiniComponent = {
	belongs: (host: ControlHost, ancestor: ControlHost) -> boolean,
	hostVisible: (host: ControlHost) -> boolean,
	gearSpace: (record: ControlView) -> number,
	gearHit: (record: ControlView, event: InputObject?) -> boolean,
	placeGear: (record: ControlView) -> (),
	inside: (app: App, at: Vector2) -> boolean,
	closeBranch: (app: App, depth: number) -> (),
	closeHost: (app: App, host: ControlHost) -> (),
	clampScroll: (node: MiniRecord) -> (),
	layout: (node: MiniRecord) -> (),
	open: (node: MiniRecord) -> (),
	destroy: (node: MiniRecord) -> (),
	destroyAll: (app: App) -> (),
	loadIcon: (app: App) -> (),
	create: (record: ControlView) -> MiniHandle,
}
type FloatingComponent = {
	anchorVisible: (record: ControlView, anchor: GuiObject) -> boolean,
	clamp: (app: App, position: Vector2, size: Vector2, margin: number) -> Vector2,
	matches: (pointer: InputObject, event: InputObject, ended: boolean?) -> boolean,
	hit: (app: App, at: Vector2) -> boolean,
	pointer: (event: InputObject) -> boolean,
	move: (app: App, event: InputObject) -> (),
}
type ColorsComponent = {
	accent: (App) -> Color3, contrast: (Color3) -> Color3, paintAccent: (App) -> (),
	validate: (value: Color3) -> (),
	close: (app: App) -> (),
	refresh: (popup: ColorPopup) -> (),
	paint: (record: ColorRecord) -> (),
	set: (record: ColorRecord,value: Color3,options: ValueSetOptions?,fromPointer: boolean?) -> (),
	place: (popup: ColorPopup) -> (),
	pointer: (popup: ColorPopup,at: Vector2,isHue: boolean) -> (),
	open: (record: ColorRecord) -> (),
}
type SlidersComponent = {
	isFinite: (value: unknown) -> boolean,
	decimals: (value: number) -> number,
	normalize: (record: SliderRecord,value: number) -> number,
	format: (record: SliderRecord) -> string,
	sizeField: (record: SliderRecord) -> (),
	paint: (record: SliderRecord, instant: boolean?) -> (),
	finish: (record: SliderRecord,commit: boolean) -> (),
	cancel: (record: SliderRecord) -> (),
	pointer: (record: SliderRecord,at: Vector2) -> (),
	begin: (record: SliderRecord,event: InputObject) -> (),
}
type CursorComponent = {
	bridge: (app: App) -> any,
	maintain: (app: App) -> (),
	release: (app: App) -> (),
	acquire: (app: App) -> (),
}
type ConfigsComponent = {
	name: (string) -> string, close: (App, boolean?) -> (), interactive: (App) -> boolean,
	disarm: (App) -> (), confirm: (App, string, string) -> boolean,
	flash: (App, string) -> (),
	paint: (App) -> (), refresh: (App) -> (), encode: (App) -> string,
	decode: (ControlRecord, any) -> any, load: (App, string, ValueSetOptions?) -> ConfigLoadReport,
	record: (App, string) -> ControlRecord, value: (ControlRecord) -> any,
	snapshot: (App) -> any, apply: (App, any, ValueSetOptions?) -> ConfigLoadReport,
	call: (App, string, string?, ValueSetOptions?) -> any, list: (App) -> { string }, ensure: (App) -> (),
	run: (App, string) -> (), toggle: (App) -> (), build: (App) -> (),
}
type InputComponent = {
	resizeVisual: (app: App) -> (),
	finish: (app: App) -> (),
	begin: (app: App, event: InputObject, kind: string) -> (),
	connect: (app: App) -> (),
}
type BootstrapComponent = {
	complete: (app: App, stage: string) -> (),
	icons: (app: App) -> (),
	run: (app: App) -> (),
}
local Application: { [string]: any } = {}
Application.__index = Application
type MotionComponent = {
	cancelMenu: (App) -> (), cancelSections: (App, boolean?) -> (), cancel: (App) -> (),
	intro: (App) -> (), prepare: (App, string, TabRecord?) -> (), policy: (App) -> (),
	layout: (App, { SectionSlot }, SectionDrag?) -> (),
	to: (App, Scope, Instance, { [string]: any }, number, (() -> ())?, boolean?) -> Scope?,
	popup: (App, DropdownPopup, boolean) -> (),
	alpha: (App, Instance, string, number) -> (),
}
local Motion: MotionComponent = {} :: any

type AppStatus = { Phase: string, Error: string?, Stage: string, CompletedStages: number, TotalStages: number, Visible: boolean, Gesture: string?, CursorOwned: boolean, TabCount: number }
type SectionStatus = { Collapsed: boolean, Destroyed: boolean, Participating: boolean, Column: number, Position: Vector2, Size: Vector2, Dragging: boolean, ContentVisible: boolean }
type ContentStatus = { Columns: number, CardWidth: number, CanvasHeight: number, ScrollPosition: Vector2, Sections: { { Id: string, TabId: string, Collapsed: boolean, Column: number, Position: Vector2, Size: Vector2 } }, DraggingId: string?, PendingIndex: number?, PreviewOrder: { string } }
local Tab: { [string]: any } = {}
Tab.__index = Tab
export type TabHandle = {
	IsActive: (TabHandle) -> boolean, SetActive: (TabHandle, boolean) -> (),
	GetMetadata: (TabHandle) -> { Id: string, Name: string, Icon: string }, GetButton: (TabHandle) -> ImageButton?,
	GetStatus: (TabHandle) -> { Active: boolean, Hovered: boolean, IconOutcome: string, Destroyed: boolean },
	AddSection: (TabHandle, SectionOptions) -> SectionHandle, GetSection: (TabHandle, string) -> SectionHandle?,
	Destroy: (TabHandle) -> (), IsDestroyed: (TabHandle) -> boolean,
}
local Tabs: TabsComponent = {} :: any
local Section: { [string]: any } = {}
Section.__index = Section
export type SectionHandle = {
	AddToggle: (SectionHandle, ToggleOptions) -> ToggleHandle, GetToggle: (SectionHandle, string) -> ToggleHandle?,
	AddDropdown: (SectionHandle, DropdownOptions) -> DropdownHandle, AddMultiDropdown: (SectionHandle, MultiDropdownOptions) -> MultiDropdownHandle,
	AddKeybind: (SectionHandle, KeybindOptions) -> KeybindHandle, AddButton: (SectionHandle, ButtonOptions) -> ButtonHandle,
	AddColorPicker: (SectionHandle, ColorPickerOptions) -> ColorPickerHandle, AddSlider: (SectionHandle, SliderOptions) -> SliderHandle,
	GetMetadata: (SectionHandle) -> HostMetadata, IsCollapsed: (SectionHandle) -> boolean,
	SetCollapsed: (SectionHandle, boolean) -> (), GetContent: (SectionHandle) -> Frame,
	GetHeader: (SectionHandle) -> Frame?, GetDragHandle: (SectionHandle) -> ImageButton?,
	GetStatus: (SectionHandle) -> SectionStatus, Destroy: (SectionHandle) -> (),
}
local Sections: SectionsComponent = {} :: any
local Toggle: { [string]: any } = {}
Toggle.__index = Toggle
export type ToggleHandle = {
	Get: (ToggleHandle) -> boolean, Set: (ToggleHandle, boolean, ToggleSetOptions?) -> (),
	GetMetadata: (ToggleHandle) -> ControlMetadata, GetButton: (ToggleHandle) -> TextButton?,
	IsDestroyed: (ToggleHandle) -> boolean, Destroy: (ToggleHandle) -> (), CreateMiniSection: (ToggleHandle) -> MiniHandle,
}
local Dropdown = {}
Dropdown.__index = Dropdown
export type DropdownHandle = {
	Get: (DropdownHandle) -> string, Set: (DropdownHandle, string, ValueSetOptions?) -> (), SetValues: (DropdownHandle, { string }, ValueSetOptions?) -> (),
	GetMetadata: (DropdownHandle) -> ControlMetadata, GetButton: (DropdownHandle) -> TextButton?,
	IsDestroyed: (DropdownHandle) -> boolean, Destroy: (DropdownHandle) -> (), CreateMiniSection: (DropdownHandle) -> MiniHandle,
}
local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown
export type MultiDropdownHandle = {
	Get: (MultiDropdownHandle) -> { string }, Set: (MultiDropdownHandle, { string }, ValueSetOptions?) -> (), SetValues: (MultiDropdownHandle, { string }, ValueSetOptions?) -> (),
	GetMetadata: (MultiDropdownHandle) -> ControlMetadata, GetButton: (MultiDropdownHandle) -> TextButton?,
	IsDestroyed: (MultiDropdownHandle) -> boolean, Destroy: (MultiDropdownHandle) -> (), CreateMiniSection: (MultiDropdownHandle) -> MiniHandle,
}
local Button = {}
Button.__index = Button
export type ButtonHandle = {
	GetMetadata: (ButtonHandle) -> ControlMetadata, GetButton: (ButtonHandle) -> TextButton?,
	IsDestroyed: (ButtonHandle) -> boolean, Destroy: (ButtonHandle) -> (), IsDisabled: (ButtonHandle) -> boolean,
	SetDisabled: (ButtonHandle, boolean) -> (), CreateMiniSection: (ButtonHandle) -> MiniHandle,
	Press: (ButtonHandle) -> boolean, IsBusy: (ButtonHandle) -> boolean, IsCompleted: (ButtonHandle) -> boolean,
}
local Keybind = {}
Keybind.__index = Keybind
export type KeybindHandle = {
	Get: (KeybindHandle) -> EnumItem?, Set: (KeybindHandle, EnumItem?, ValueSetOptions?) -> (),
	GetMetadata: (KeybindHandle) -> ControlMetadata, GetButton: (KeybindHandle) -> TextButton?,
	IsDestroyed: (KeybindHandle) -> boolean, Destroy: (KeybindHandle) -> (), CreateMiniSection: (KeybindHandle) -> MiniHandle,
}
local MiniSection = {}
MiniSection.__index = MiniSection
export type MiniHandle = {
	AddToggle: (MiniHandle, ToggleOptions) -> ToggleHandle, GetToggle: (MiniHandle, string) -> ToggleHandle?,
	AddDropdown: (MiniHandle, DropdownOptions) -> DropdownHandle, AddMultiDropdown: (MiniHandle, MultiDropdownOptions) -> MultiDropdownHandle,
	AddKeybind: (MiniHandle, KeybindOptions) -> KeybindHandle, AddButton: (MiniHandle, ButtonOptions) -> ButtonHandle,
	AddColorPicker: (MiniHandle, ColorPickerOptions) -> ColorPickerHandle, AddSlider: (MiniHandle, SliderOptions) -> SliderHandle,
	GetMetadata: (MiniHandle) -> HostMetadata, GetContent: (MiniHandle) -> Frame,
	GetRoot: (MiniHandle) -> Frame?, GetGear: (MiniHandle) -> ImageButton?, GetDragHandle: (MiniHandle) -> TextButton?,
	IsOpen: (MiniHandle) -> boolean, IsDestroyed: (MiniHandle) -> boolean, Destroy: (MiniHandle) -> (),
}
local Mini: MiniComponent = {} :: any
local ColorPicker = {}
ColorPicker.__index = ColorPicker
export type ColorPickerHandle = {
	Get: (ColorPickerHandle) -> Color3, Set: (ColorPickerHandle, Color3, ValueSetOptions?) -> (),
	GetMetadata: (ColorPickerHandle) -> ControlMetadata, GetButton: (ColorPickerHandle) -> TextButton?,
	IsDestroyed: (ColorPickerHandle) -> boolean, Destroy: (ColorPickerHandle) -> (), CreateMiniSection: (ColorPickerHandle) -> MiniHandle,
}
local Slider = {}
Slider.__index = Slider
export type SliderHandle = {
	Get: (SliderHandle) -> number, Set: (SliderHandle, number, ValueSetOptions?) -> (),
	GetMetadata: (SliderHandle) -> ControlMetadata, GetButton: (SliderHandle) -> TextBox?, GetTrack: (SliderHandle) -> Frame?,
	IsDestroyed: (SliderHandle) -> boolean, Destroy: (SliderHandle) -> (), CreateMiniSection: (SliderHandle) -> MiniHandle,
}
type TabInternal = TabHandle & { _record: TabRecord }
type SectionInternal = SectionHandle & { _record: SectionRecord }
type ToggleInternal = ToggleHandle & { _record: ToggleRecord }
type DropdownInternal = DropdownHandle & { _record: DropdownRecord }
type MultiDropdownInternal = MultiDropdownHandle & { _record: MultiDropdownRecord }
type ButtonInternal = ButtonHandle & { _record: ButtonRecord }
type KeybindInternal = KeybindHandle & { _record: KeybindRecord }
type MiniInternal = MiniHandle & { _record: MiniRecord }
type ColorPickerInternal = ColorPickerHandle & { _record: ColorRecord }
type SliderInternal = SliderHandle & { _record: SliderRecord }
local Sliders: SlidersComponent = {} :: any
local SliderStyle = table.freeze({ Height=40, Header=20, HeaderY=1, TrackY=30, TrackHeight=4, Thumb=8, HitHeight=18, MinimumField=28, MaximumField=106 })
local ButtonStyle = table.freeze({ Width=42, Height=20, Icon=14, FlashSeconds=0.2 })
local Colors: ColorsComponent = {} :: any
local Floating: FloatingComponent = {} :: any
local Controls: ControlsComponent = {} :: any
local Modes: ModesComponent = {} :: any
local Input: InputComponent = {} :: any

-- pcall may return an error even when a callback has no declared results.
-- Its variadic result contract is explicit at this single dynamic boundary.
-- A single dynamic boundary for executor/owner calls. Erase pcall's generic
-- packs here so recursive component types do not expand at every call site.
local protected: (...any) -> (boolean, ...any) = pcall :: any
local function diagnostic(message: string): ()
	pcall(warn, "[ScriptUI_defolt] " .. message)
end
local function safe(callback: () -> ...any): ()
	local ok, problem = protected(callback)
	if not ok then diagnostic("cleanup: " .. tostring(problem)) end
end
local function scope(): Scope
	return { Closed = false, Cleanup = {}, Tasks = {} }
end
local Resources: ResourcesComponent = {} :: any
function Resources.add(owner: Scope, dispose: () -> ()): () -> ()
	if owner.Closed then safe(dispose); return function() end end
	table.insert(owner.Cleanup, dispose)
	-- Detach without running disposal. Closed child owners leave no tombstones
	-- or retained closures in a long-lived parent.
	return function()
		if owner.Closed then return end
		local index = table.find(owner.Cleanup, dispose)
		if index then table.remove(owner.Cleanup, index) end
	end
end
function Resources.own(parent: Scope, child: Scope, dispose: (() -> ())?): ()
	local detach = Resources.add(parent, dispose or function() Resources.close(child) end)
	Resources.add(child, detach)
end
function Resources.close(owner: Scope): ()
	if owner.Closed then return end
	owner.Closed = true
	local callbacks, tasks = owner.Cleanup, owner.Tasks
	owner.Cleanup, owner.Tasks = {}, {}
	for index = #callbacks, 1, -1 do safe(callbacks[index]) end
	for worker in tasks do
		if worker ~= coroutine.running() and coroutine.status(worker) ~= "dead" then
			safe(function() task.cancel(worker) end)
		end
	end
end
function Resources.spawn(owner: Scope, callback: () -> ()): thread?
	if owner.Closed then return nil end
	local worker: thread = task.defer(function()
		local ok, problem = protected(function() if not owner.Closed then callback() end end)
		owner.Tasks[coroutine.running()] = nil
		if not ok and not owner.Closed then diagnostic("owned task: " .. tostring(problem)) end
	end)
	owner.Tasks[worker] = true
	return worker
end
function Resources.connect(owner: Scope, signal: RBXScriptSignal, callback: (...any) -> ()): ()
	if owner.Closed then return end
	local connection = signal:Connect(function(...)
		if not owner.Closed then callback(...) end
	end)
	Resources.add(owner, function() connection:Disconnect() end)
end
function Resources.tween(owner: Scope, tween: Tween): ()
	Resources.add(owner, function()
		safe(function() tween:Cancel() end)
		safe(function() tween:Destroy() end)
	end)
end
local function alive(app: App): boolean
	return app._life.Phase == "loading" or app._life.Phase == "ready"
end
local function finite(value: unknown): boolean
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end
local function vector(value: Vector2?, fallback: Vector2): Vector2
	if value == nil then return fallback end
	assert(typeof(value) == "Vector2" and finite(value.X) and finite(value.Y), "Expected a finite Vector2")
	return value
end

-- Environment discovery uses the Real primitives verified with search-api.
local Runtime: RuntimeComponent = {} :: any
function Runtime.discover(provided: IconCapabilities?): Environment
	local globals = if type(getgenv) == "function" then getgenv() else getfenv(0)
	local base = getfenv(0)
	local function primitive(name: string): any
		return globals[name] or base[name]
	end
	local capabilities: IconCapabilities = if provided then table.clone(provided) else {
		Request = primitive("request"), GetAsset = primitive("getcustomasset"),
		IsFile = primitive("isfile"), ReadFile = primitive("readfile"), WriteFile = primitive("writefile"),
		IsFolder = primitive("isfolder"), MakeFolder = primitive("makefolder"),
	}
	capabilities.ListFiles = capabilities.ListFiles or primitive("listfiles")
	return {
		Globals = globals, Capabilities = capabilities,
		Input = (game:GetService("UserInputService") :: UserInputService), Run = (game:GetService("RunService") :: RunService),
		Players = (game:GetService("Players") :: Players), Actions = (game:GetService("ContextActionService") :: ContextActionService),
		Content = (game:GetService("ContentProvider") :: ContentProvider), Player = nil,
	}
end
function Runtime.parent(app: App, requested: Instance?): Instance
	if requested then return requested end
	local get = app._env.Globals.gethui or getfenv(0).gethui
	if type(get) == "function" then
		local ok, parent = protected(get)
		if ok and typeof(parent) == "Instance" then return parent end
	end
	return game:GetService("CoreGui")
end
function Runtime.prepare(app: App): ()
	local caps = app._env.Capabilities
	assert(caps.IsFolder and caps.MakeFolder, "Real filesystem folder primitives unavailable")
	for _, path in { Paths.Root, Paths.UI, Paths.Icons, Paths.Background } do
		if not alive(app) then return end
		if not caps.IsFolder(path) then
			assert(not caps.IsFile or not caps.IsFile(path), "File obstructs directory: " .. path)
			if not alive(app) then return end
			caps.MakeFolder(path)
		end
		if not alive(app) then return end
		assert(caps.IsFolder(path), "Directory preparation failed: " .. path)
	end
	while alive(app) and not app._env.Players.LocalPlayer do task.wait() end
	app._env.Player = app._env.Players.LocalPlayer
end

-- Exact existing v2 disk protocol. This is a format implementation, not an old
-- UI resolver dependency: only registered tab icons, no aliases/subscriptions/CFG.
local Icons: IconsComponent = {} :: any
local function digest(bytes: string): string
	local a, b, c, d = 5381, 52711, 104729, 15485863
	for index = 1, #bytes do
		local byte = string.byte(bytes, index)
		a = (a * 33 + byte) % 2147483647
		b = (b * 131 + byte) % 2147483647
		c = (c * 257 + byte) % 2147483647
		d = (d * 65599 + byte) % 2147483647
	end
	return string.format("%08x%08x%08x%08x", a, b, c, d)
end
function Icons.source(spec: string): string
	assert(type(spec) == "string", "Tab Icon is required")
	local filename = if spec:sub(1, #ICON_BASE) == ICON_BASE then spec:sub(#ICON_BASE + 1) else spec
	assert(filename:match("^[%w_%-]+%.png$"), "Tab Icon must name a PNG in Atafami-Release/assets/icons")
	return ICON_BASE .. filename
end
function Tabs.validate(options: TabOptions): ()
	assert(type(options) == "table" and type(options.Id) == "string" and options.Id:match("^[%w_%-]+$"), "Tab requires a stable nonempty Id")
	assert(type(options.Name) == "string" and options.Name:match("%S"), "Tab requires a metadata Name")
	assert(options.Active == nil or type(options.Active) == "boolean", "Tab Active expects boolean")
	assert(options.Callback == nil or type(options.Callback) == "function", "Tab Callback expects function")
	Icons.source(options.Icon)
end
function Icons.path(spec: string): string
	return Paths.Icons .. "/v2-" .. digest(Icons.source(spec)) .. ".png"
end
local CRC: { number } = {}
for byte = 0, 255 do
	local value = byte
	for _ = 1, 8 do
		value = if bit32.band(value, 1) == 1 then bit32.bxor(bit32.rshift(value, 1), 0xedb88320) else bit32.rshift(value, 1)
	end
	CRC[byte + 1] = value
end
table.freeze(CRC)
local function u32(bytes: string, offset: number): number
	local a, b, c, d = string.byte(bytes, offset, offset + 3)
	return a * 16777216 + b * 65536 + c * 256 + d
end
local function validPng(bytes: any, limit: number?): boolean
	if type(bytes) ~= "string" or #bytes < 57 or #bytes > (limit or 4 * 1024 * 1024)
		or bytes:sub(1, 8) ~= string.char(137, 80, 78, 71, 13, 10, 26, 10) then return false end
	local offset, header, pixels, endedPixels, palette = 9, false, false, false, false
	local colorType = -1
	while offset + 11 <= #bytes do
		local length = u32(bytes, offset)
		local last = offset + 7 + length
		if last + 4 > #bytes then return false end
		local kind = bytes:sub(offset + 4, offset + 7)
		if not kind:match("^[A-Za-z][A-Za-z][A-Z][A-Za-z]$") then return false end
		local checksum = 0xffffffff
		for index = offset + 4, last do
			checksum = bit32.bxor(bit32.rshift(checksum, 8), CRC[bit32.band(bit32.bxor(checksum, string.byte(bytes, index)), 255) + 1])
		end
		if bit32.bxor(checksum, 0xffffffff) ~= u32(bytes, last + 1) then return false end
		if not header then
			if kind ~= "IHDR" or length ~= 13 then return false end
			local width, height = u32(bytes, offset + 8), u32(bytes, offset + 12)
			local depth, color, compression, filter, interlace = string.byte(bytes, offset + 16, offset + 20)
			local depths = if color == 0 then { 1, 2, 4, 8, 16 } elseif color == 3 then { 1, 2, 4, 8 }
				elseif color == 2 or color == 4 or color == 6 then { 8, 16 } else {}
			if width < 1 or height < 1 or width > 16384 or height > 16384 or not table.find(depths, depth)
				or compression ~= 0 or filter ~= 0 or interlace > 1 then return false end
			header, colorType = true, color
		elseif kind == "IHDR" then return false
		elseif kind == "PLTE" then
			if palette or pixels or length < 3 or length > 768 or length % 3 ~= 0 then return false end
			palette = true
		elseif kind == "IDAT" then
			if endedPixels or (colorType == 3 and not palette) then return false end
			if length > 0 then pixels = true end
		elseif kind == "IEND" then return pixels and length == 0 and last + 4 == #bytes
		else
			if kind:match("^[A-Z]") then return false end
			if pixels then endedPixels = true end
		end
		offset = last + 5
	end
	return false
end
function Icons.resolve(app: App, source: string, current: () -> boolean): (string?, string)
	local caps, stats = app._env.Capabilities, app._icons.Stats
	local path = Icons.path(source)
	assert(caps.IsFile and caps.ReadFile and caps.WriteFile and caps.GetAsset, "Real icon filesystem/asset primitives unavailable")
	local function valid(bytes: any): boolean
		return validPng(bytes)
	end
	local function register(): string?
		if not current() then return nil end
		local ok, asset = protected(caps.GetAsset, path)
		if not current() or not ok or type(asset) ~= "string" or asset == "" then return nil end
		local fetched = false
		local decoded = protected(function()
			app._env.Content:PreloadAsync({ asset }, function(_, status)
				if current() and status == Enum.AssetFetchStatus.Success then fetched = true end
			end)
		end)
		if not current() then return nil end
		-- IsLoaded belongs to the renderer and stays false under the hidden menu.
		-- Preload's fetch result is the bootstrap gate; visual QA checks IsLoaded
		-- after opening. A valid warm file is never redownloaded just for hiding.
		if decoded and fetched then return asset end
		return nil
	end
	local function disk(): (string?, boolean)
		local okFile, exists = protected(caps.IsFile, path)
		if not current() or not okFile or not exists then return nil, false end
		local ok, bytes = protected(caps.ReadFile, path)
		if not current() then return nil, false end
		local okMeta, meta = protected(caps.ReadFile, path .. ".meta")
		if not current() then return nil, false end
		if ok and valid(bytes) and okMeta and meta == source .. "\n" .. digest(bytes) then
			local asset = register()
			if not current() then return nil, false end
			if asset then stats.DiskHits += 1; return asset, true end
			-- Valid bytes were already tried. HTTP cannot repair a registration
			-- or decoder failure, and must not rewrite a verified warm cache.
			return nil, true
		end
		stats.CorruptCache += 1
		return nil, false
	end
	local asset, verified = disk()
	if not current() then return nil, "cancelled" end
	if asset then return asset, "disk" end
	if verified then return nil, "fallback" end
	assert(caps.Request, "Real HTTP request primitive unavailable")
	stats.NetworkRequests += 1
	local response = caps.Request({ Url = source, Method = "GET", Headers = { Accept = "image/png" } })
	if not current() then return nil, "cancelled" end
	local status = if type(response) == "table" then tonumber(response.StatusCode or response.Status) else nil
	assert(type(response) == "string" or (type(response) == "table" and response.Success ~= false
		and (status == nil or (status >= 200 and status < 300))), "Icon HTTP failed: " .. tostring(status))
	local bytes = if type(response) == "string" then response else response.Body or response.body
	assert(valid(bytes), "Image response failed PNG or pinned resource validation")
	asset = disk() -- A previous/native owner can finish while HTTP is yielding.
	if not current() then return nil, "cancelled" end
	if asset then return asset, "disk" end
	caps.WriteFile(path, bytes)
	if not current() then return nil, "cancelled" end
	local meta = source .. "\n" .. digest(bytes)
	caps.WriteFile(path .. ".meta", meta)
	if not current() then return nil, "cancelled" end
	local written = caps.ReadFile(path)
	if not current() then return nil, "cancelled" end
	local writtenMeta = caps.ReadFile(path .. ".meta")
	if not current() then return nil, "cancelled" end
	assert(written == bytes and writtenMeta == meta, "Icon cache write verification failed")
	asset = register()
	if not current() then return nil, "cancelled" end
	assert(asset, "Icon registration/decode failed")
	return asset, "download"
end

-- GUI construction; loading shell is acquired before any yielding bootstrap.
local Gui: GuiComponent = {} :: any
local Background: BackgroundComponent = {} :: any
local Cursor: CursorComponent = {} :: any
local Configs: ConfigsComponent = {} :: any
function Gui.showing(app: App): boolean
	return app._life.Phase == "ready" and app._life.Visible
		and app.Root ~= nil and app.Root.Visible and app.ScreenGui ~= nil and app.ScreenGui.Enabled
end
function Gui.sync(app: App): ()
	if not Gui.showing(app) then
		Motion.cancel(app); Input.finish(app); Tabs.clearHover(app)
		Modes.releaseSearch(app); Cursor.release(app)
	else
		local ok, problem = protected(Cursor.acquire, app)
		if not ok then app:_fail("cursor/camera acquisition: " .. tostring(problem)); return end
		Modes.paint(app); Modes.focus(app)
	end
	if app._view.Overlay then app._view.Overlay.Visible = Gui.showing(app) end
	if app._view.Grip then app._view.Grip.Visible = Gui.showing(app) end
	Background.visible(app)
end
local function create(app: App, kind: string, name: string, parent: Instance?, layer: number?, properties: { [string]: any }?, owner: Scope?): any
	local object = Instance.new(kind)
	Resources.add(owner or app._scope, function() object:Destroy() end)
	object.Name = name
	if object:IsA("GuiObject") then
		object.BorderSizePixel = 0
		object.ZIndex = layer :: number
	end
	local attributes: { [string]: any } = properties or {}
	for key, value in attributes do (object :: any)[key] = value end
	object.Parent = parent
	return object
end
local function corner(app: App, parent: Instance, radius: number, owner: Scope?): ()
	create(app, "UICorner", "Corner", parent, nil, { CornerRadius = UDim.new(0, radius) }, owner)
end
local function edgeCorners(app: App, parent: Instance, top: number, bottom: number): ()
	local rounded = create(app, "UICorner", "Corner", parent, nil)
	-- Assign per-corner radii explicitly; CornerRadius can overwrite all four.
	rounded.TopLeftRadius, rounded.TopRightRadius = UDim.new(0, top), UDim.new(0, top)
	rounded.BottomLeftRadius, rounded.BottomRightRadius = UDim.new(0, bottom), UDim.new(0, bottom)
end
local function stroke(app: App, parent: Instance, color: Color3, owner: Scope?): ()
	create(app, "UIStroke", "Outline", parent, nil, { Thickness = 1, Color = color, Transparency = 0.2 }, owner)
end
local function line(app: App, parent: Instance, name: string, layer: number, position: UDim2, size: UDim2, color: Color3, rotation: number?, owner: Scope?): Frame
	return create(app, "Frame", name, parent, layer, { Position = position, Size = size, BackgroundColor3 = color, Rotation = rotation or 0 }, owner)
end
local function dividerFade(app: App, parent: Frame, rotation: number): ()
	create(app, "UIGradient", "Fade", parent, nil, { Rotation = rotation, Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.18, 0.4), NumberSequenceKeypoint.new(0.5, 0.05),
		NumberSequenceKeypoint.new(0.82, 0.4), NumberSequenceKeypoint.new(1, 1),
	}) })
end
-- Local menu images are user data: never downloaded, overwritten, or deleted here.
function Background.path(file: string): string
	assert(type(file) == "string" and #file > 0 and #file <= 200 and not file:find("[%c/\\:]")
		and file ~= "." and file ~= ".." and file:sub(1, 1) ~= ".", "Expected a menu image filename")
	assert(file:lower():match("%.png$") or file:lower():match("%.jpe?g$"), "Menu images must be PNG or JPEG")
	return Paths.Background .. "/" .. file
end
function Background.valid(bytes: string, file: string): boolean
	if #bytes > 16 * 1024 * 1024 then return false end
	local function dimensions(width: number, height: number): boolean
		return width > 0 and height > 0 and width <= 8192 and height <= 8192 and width * height <= 16777216
	end
	if file:lower():match("%.png$") then
		return validPng(bytes, 16 * 1024 * 1024) and dimensions(u32(bytes, 17), u32(bytes, 21))
	end
	if #bytes < 4 or bytes:sub(1, 2) ~= string.char(255, 216) then return false end
	local cursor = 3
	while cursor + 3 <= #bytes do
		if bytes:byte(cursor) ~= 255 then return false end
		repeat cursor += 1 until cursor > #bytes or bytes:byte(cursor) ~= 255
		local marker = bytes:byte(cursor)
		if not marker or marker == 217 or marker == 218 then return false end
		cursor += 1
		if marker == 1 or (marker >= 208 and marker <= 215) then continue end
		if cursor + 1 > #bytes then return false end
		local length = (bytes:byte(cursor) :: number) * 256 + (bytes:byte(cursor + 1) :: number)
		if length < 2 or cursor + length > #bytes + 1 then return false end
		if marker >= 192 and marker <= 207 and marker ~= 196 and marker ~= 200 and marker ~= 204 then
			if length < 8 then return false end
			local height = (bytes:byte(cursor + 3) :: number) * 256 + (bytes:byte(cursor + 4) :: number)
			local width = (bytes:byte(cursor + 5) :: number) * 256 + (bytes:byte(cursor + 6) :: number)
			return dimensions(width, height)
		end
		cursor += length
	end
	return false
end
function Background.list(app: App): { string }
	local caps = app._env.Capabilities
	local names, seen = { "Default" }, {}
	if not caps.ListFiles or not caps.IsFile then return names end
	local ok, entries = protected(caps.ListFiles, Paths.Background)
	if not ok or type(entries) ~= "table" then return names end
	assert(alive(app), "Menu was destroyed")
	local files: { string } = {}
	for _, entry in entries do
		if type(entry) ~= "string" then continue end
		local file = entry:gsub("\\", "/"):match("([^/]+)$")
		local valid, path = protected(Background.path, file)
		if valid and file and not seen[file] then
			local checked, exists = protected(caps.IsFile, path)
			assert(alive(app), "Menu was destroyed")
			if checked and exists == true then seen[file] = true; table.insert(files, file) end
		end
	end
	table.sort(files)
	for _, file in files do table.insert(names, file) end
	return names
end
function Background.refresh(app: App): { string }
	local names = Background.list(app)
	local record = app._background.Selection
	if record and not record.Scope.Closed then
		-- A missing selected file stays serializable, while rendering falls back.
		if not table.find(names, record.Model.Value) then table.insert(names, record.Model.Value) end
		(record.Handle :: DropdownHandle):SetValues(names, { Emit = false })
	end
	Background.request(app)
	return table.clone(names)
end
function Background.paint(app: App): ()
	local background = app._background
	local dim = if background.Dimming then background.Dimming.Model.Value else background.Dim
	local color = if background.Accent then background.Accent.Model.Value else background.Color
	background.Dim, background.Color = dim, color
	if app.Root then app.Root.BackgroundColor3 = color end
	if background.Shade then
		background.Shade.BackgroundColor3 = color
		background.Shade.BackgroundTransparency = 1 - dim
	end
end
function Background.select(app: App): ()
	local record = app._background.Selection
	if not record then return end
	app._background.File = if record.Model.Value == "Default" then nil else record.Model.Value
	Background.request(app)
end
function Background.visible(app: App): ()
	if app._background.Root then app._background.Root.Visible = Gui.showing(app) end
end
function Background.request(app: App): ()
	local background = app._background
	if not alive(app) or background.Scope.Closed or not background.Image then return end
	background.Revision += 1
	if background.Work then Resources.close(background.Work) end
	background.Image.Visible, background.Image.Image = false, ""
	local file = background.File
	if not file then background.Outcome = "default"; return end
	local owner, revision = scope(), background.Revision
	local deadline = os.clock() + app._life.IconTimeout
	background.Work, background.Outcome = owner, "loading"
	local stats = background.Stats
	stats.WorkerStarts += 1; stats.Pending += 1
	Resources.own(background.Scope, owner)
	Resources.add(owner, function()
		stats.Pending -= 1
		if background.Work == owner then
			background.Work = nil
			if background.Outcome == "loading" then background.Outcome = "cancelled" end
		end
	end)
	local function current(): boolean
		return alive(app) and not owner.Closed and background.Revision == revision and os.clock() < deadline
	end
	Resources.spawn(owner, function()
		local ok, problem = protected(function()
			local caps, path = app._env.Capabilities, Background.path(file)
			assert(caps.IsFile and caps.ReadFile and caps.GetAsset, "Local image access unavailable")
			assert(caps.IsFile(path), "Menu image missing: " .. file)
			if not current() then return end
			local bytes = caps.ReadFile(path)
			if not current() then return end
			assert(type(bytes) == "string" and Background.valid(bytes, file), "Invalid or oversized menu image: " .. file)
			local asset = caps.GetAsset(path)
			if not current() then return end
			assert(type(asset) == "string" and asset ~= "", "Menu image registration failed")
			local fetched = false
			app._env.Content:PreloadAsync({ asset }, function(_, status)
				if current() and status == Enum.AssetFetchStatus.Success then fetched = true end
			end)
			if not current() then return end
			assert(fetched, "Menu image could not be decoded")
			local image = background.Image
			if image then image.Image, image.Visible = asset, true end
			background.Outcome = "disk"; stats.DiskHits += 1
		end)
		if current() then
			if not ok then background.Outcome = "fallback"; stats.Failures += 1; diagnostic(tostring(problem)) end
			Resources.close(owner)
		end
	end)
	Resources.spawn(owner, function()
		while not owner.Closed and os.clock() < deadline do task.wait() end
		if not owner.Closed then
			background.Outcome = "fallback"; stats.Failures += 1
			diagnostic("Menu image deadline exceeded: " .. file)
			Resources.close(owner)
		end
	end)
end
function Background.build(app: App): ()
	local background, root = app._background, app._view.Root :: Frame
	root.BackgroundColor3 = background.Color
	background.Root = create(app, "CanvasGroup", "MenuBackground", root, Layers.Decoration, {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true,
		Active = false, Selectable = false, GroupTransparency = 0,
	}, background.Scope)
	corner(app, background.Root :: CanvasGroup, Appearance.Radius, background.Scope)
	background.Image = create(app, "ImageLabel", "Wallpaper", background.Root, Layers.Decoration, {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "", Visible = false,
		ScaleType = Enum.ScaleType.Crop, Active = false, Selectable = false,
	}, background.Scope)
	background.Shade = create(app, "Frame", "Shade", background.Root, Layers.Decoration, {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = background.Color, BackgroundTransparency = 1 - background.Dim,
		Active = false, Selectable = false,
	}, background.Scope)
	Resources.add(background.Scope, function()
		background.Revision += 1
		background.Root, background.Image, background.Shade, background.Selection, background.Dimming, background.Accent = nil, nil, nil, nil, nil, nil
	end)
end
function Background.start(app: App): ()
	Background.paint(app)
	-- Images never block the required icon/input bootstrap.
	Background.request(app)
end
function Gui.shell(app: App, parent: Instance): ()
	local view = app._view
	view.Screen = create(app, "ScreenGui", "AtafamiScriptUIFoundation", nil, nil, {
		DisplayOrder = DISPLAY_ORDER, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true, ResetOnSpawn = false,
	})
	app.ScreenGui = view.Screen
	Resources.connect(app._scope, (view.Screen :: ScreenGui).Destroying, function() app:Destroy() end)
	Resources.connect(app._scope, (view.Screen :: ScreenGui).AncestryChanged, function(_, nextParent)
		if nextParent == nil and alive(app) then app:Destroy() end
	end)
	local screen = view.Screen :: ScreenGui
	screen.Parent = parent
	view.Canvas = create(app, "Frame", "Viewport", view.Screen, Layers.Background, {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = false,
	})
	view.Loading = create(app, "Frame", "Loading", view.Canvas, Layers.Loading, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(220, 70), BackgroundColor3 = Appearance.Card,
	})
	corner(app, view.Loading :: Frame, Appearance.Radius)
	stroke(app, view.Loading :: Frame, Appearance.Divider)
	local track = create(app, "Frame", "ProgressTrack", view.Loading, Layers.Loading, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -36, 0, 3), BackgroundColor3 = Appearance.Button,
	})
	corner(app, track, 2)
	view.Progress = create(app, "Frame", "Progress", track, Layers.Loading, {
		Size = UDim2.fromScale(0, 1), BackgroundColor3 = Appearance.White,
	})
	corner(app, view.Progress :: Frame, 2)
end
function Gui.chrome(app: App, surface: Frame, top: number, bottom: number): ()
	edgeCorners(app, surface, top, bottom)
	surface.BackgroundColor3 = Color3.new(1, 1, 1)
	create(app, "UIGradient", "Graphite", surface, nil, { Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(28, 28, 28), Color3.fromRGB(18, 18, 18)),
	})
end
function Gui.footer(app: App): ()
	local view = app._view
	local footer = create(app, "Frame", "BottomPanel", view.Root, Layers.Panel, {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, Appearance.FooterHeight), BackgroundColor3 = Appearance.Panel,
		ClipsDescendants = true, Active = false, Selectable = false,
	})
	view.Footer = footer
	Gui.chrome(app, footer, 0, Appearance.Radius)
	local divider = line(app, footer, "Divider", Layers.Panel, UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 1), Appearance.Divider)
	dividerFade(app, divider, 0)
	local version = app._preferences.ScriptVersion
	local suffix = if version then " / " .. version else ""
	local label = create(app, "TextLabel", "Information", footer, Layers.Panel, {
		Position = UDim2.fromOffset(10, 1), Size = UDim2.new(1, -20, 1, -1), BackgroundTransparency = 1,
		Text = "Place " .. tostring(game.PlaceId) .. suffix, TextSize = 11, FontFace = REGULAR_FACE,
		TextColor3 = Appearance.MutedText, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd, RichText = false, Active = false, Selectable = false,
	}) :: TextLabel
	view.FooterText = label
	local owned = scope()
	Resources.own(app._scope, owned)
	local deadline = os.clock() + 8
	Resources.spawn(owned, function()
		repeat task.wait(0.1) until owned.Closed or os.clock() >= deadline
		if not owned.Closed then Resources.close(owned) end
	end)
	Resources.spawn(owned, function()
		local ok, info = protected(function() return game:GetService("MarketplaceService"):GetProductInfoAsync(game.PlaceId, Enum.InfoType.Asset) end)
		if owned.Closed or not alive(app) or os.clock() >= deadline or view.FooterText ~= label then return end
		if ok and type(info) == "table" and type(info.Name) == "string" and info.Name:match("%S") then
			label.Text = info.Name:gsub("%c", " ") .. suffix
		end
		Resources.close(owned)
	end)
end
function Gui.build(app: App): ()
	local view = app._view
	view.Root = create(app, "Frame", "Menu", view.Canvas, Layers.Background, {
		Visible = false, BackgroundColor3 = Appearance.Background, ClipsDescendants = false,
	})
	app.Root = view.Root
	Resources.connect(app._scope, (view.Root :: Frame).Destroying, function() app:Destroy() end)
	Resources.connect(app._scope, (view.Root :: Frame).AncestryChanged, function(_, nextParent)
		if nextParent == nil and alive(app) then app:Destroy() end
	end)
	corner(app, view.Root :: Frame, Appearance.Radius)
	stroke(app, view.Root :: Frame, Appearance.Outline)
	Background.build(app)
	view.Content = create(app, "ScrollingFrame", "Content", view.Root, Layers.Content, {
		Position = UDim2.fromOffset(0, Appearance.PanelHeight), Size = UDim2.new(1, 0, 1, -Appearance.PanelHeight - Appearance.FooterHeight),
		BackgroundTransparency = 1, ClipsDescendants = true, Active = true,
		CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.None,
		ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = Appearance.Scrollbar,
		ScrollBarImageColor3 = Appearance.Outline, VerticalScrollBarInset = Enum.ScrollBarInset.None,
		ElasticBehavior = Enum.ElasticBehavior.Never,

	})
	app.ContentRoot = view.Content
	Resources.connect(app._sections.Scope, (view.Content :: ScrollingFrame):GetPropertyChangedSignal("AbsoluteWindowSize"), function() Sections.request(app) end)
	Resources.connect(app._sections.Scope, (view.Content :: ScrollingFrame).ChildAdded, function() Sections.request(app) end)
	Resources.connect(app._sections.Scope, (view.Content :: ScrollingFrame):GetPropertyChangedSignal("CanvasPosition"), function()
		local drag = app._sections.Drag
		if drag then Sections.moveDrag(app, drag.Point) end
	end)
	Modes.build(app)
	for _, collection in app._sections.ByTab do
		for _, record in collection.Order do if record.Root then record.Root.Parent = Sections.container(app, record.Tab) end end
	end
	view.Overlay = create(app, "Frame", "Overlays", view.Canvas, Layers.Popup, {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = false, Visible = false,
	})
	app.OverlayRoot = view.Overlay
	view.MiniLayer = create(app, "Frame", "MiniSections", view.Overlay, Layers.MiniSection, {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, ClipsDescendants = false,
	})
	view.Panel = create(app, "Frame", "TopPanel", view.Root, Layers.Panel, {
		Size = UDim2.new(1, 0, 0, Appearance.PanelHeight), BackgroundColor3 = Appearance.Panel, Active = true,
	})
	for index = 1, #app._minis.Order do
		local node = app._minis.Order[index]
		local root = node.Root
		if root then root.Parent = view.MiniLayer end
		Mini.layout(node)
	end
	app.Panel = view.Panel
	Gui.chrome(app, view.Panel :: Frame, Appearance.Radius, 0)
	Gui.footer(app)
	local divider = line(app, view.Panel :: Frame, "Divider", Layers.Panel, UDim2.new(0, 0, 1, -1), UDim2.new(1, 0, 0, 1), Appearance.Divider)
	dividerFade(app, divider, 0)
	view.TabStrip = create(app, "ScrollingFrame", "TabStrip", view.Panel, Layers.Panel, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(0, Appearance.PanelHeight), BackgroundTransparency = 1, ClipsDescendants = true,
		CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.None,
		ScrollingDirection = Enum.ScrollingDirection.X, ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.Never,
	})
	app.TabStrip = view.TabStrip
	view.TabGroup = create(app, "Frame", "Tabs", view.TabStrip, Layers.Panel, {
		Size = UDim2.fromOffset(0, Appearance.PanelHeight), BackgroundTransparency = 1,
	})
	create(app, "UIListLayout", "Layout", view.TabGroup, nil, {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, Appearance.ButtonGap),
	})
	view.TabDividerSlot = create(app, "Frame", "UtilityDividerSlot", view.TabGroup, Layers.Panel, {
		Size = UDim2.fromOffset(Appearance.TabDividerSlot, 20), BackgroundTransparency = 1, Active = false, Selectable = false,
	})
	view.TabDivider = create(app, "Frame", "UtilityDivider", view.TabDividerSlot, Layers.Panel, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(2, 24), BackgroundColor3 = Appearance.Divider, Active = false, Selectable = false,
	})
	dividerFade(app, view.TabDivider :: Frame, 90)
	for _, record in app._tabs.Order do Tabs.mount(app, record) end
	Resources.connect(app._scope, (view.Root :: Frame):GetPropertyChangedSignal("Visible"), function()
		Gui.sync(app)
	end)
	Resources.connect(app._scope, (view.Screen :: ScreenGui):GetPropertyChangedSignal("Enabled"), function()
		Gui.sync(app)
	end)
	-- The stable hit area is separate from the clipped rounded contour.
	view.Grip = create(app, "TextButton", "ResizeGrip", view.Canvas, Layers.Resize, {
		AnchorPoint = Vector2.new(1, 1), Size = UDim2.fromOffset(ResizeStyle.Hit, ResizeStyle.Hit),
		BackgroundTransparency = 1, Text = "", Active = true, AutoButtonColor = false, Visible = false,
	})
	app.ResizeHandle = view.Grip
	view.ResizeVisual = create(app, "Frame", "ContourClip", view.Grip, Layers.Resize, {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1),
		Size = UDim2.fromOffset(ResizeStyle.Idle, ResizeStyle.Idle), ClipsDescendants = true, BackgroundTransparency = 1,
		Active = false, Selectable = false,
	})
	local contour = create(app, "Frame", "Contour", view.ResizeVisual, Layers.Resize, {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, ResizeStyle.Gap - ResizeStyle.Gutter, 1, ResizeStyle.Gap - ResizeStyle.Gutter),
		Size = UDim2.fromOffset(72, 72), BackgroundTransparency = 1, Active = false,
	})
	corner(app, contour, Appearance.Radius + ResizeStyle.Gap)
	view.ResizeStroke = create(app, "UIStroke", "Line", contour, nil, {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, BorderStrokePosition = Enum.BorderStrokePosition.Outer,
		Thickness = ResizeStyle.Thickness, Color = Color3.new(0.5, 0.5, 0.5), Transparency = 0,
	})
	-- The clipped arc keeps the original parallel corner. Separate round caps
	-- extend beyond the mask so neither end is cut flat by ClipsDescendants.
	create(app, "UIGradient", "Graphite", view.ResizeStroke, nil, { Rotation = 90,
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 56, 56)),
			ColorSequenceKeypoint.new((72 - ResizeStyle.Idle + ResizeStyle.Gutter - ResizeStyle.Gap) / 72, Color3.fromRGB(56, 56, 56)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 36, 36)) }),
	})
	local ends = create(app, "Frame", "RoundEnds", view.Grip, Layers.Resize, {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1),
		Size = UDim2.fromOffset(ResizeStyle.Idle, ResizeStyle.Idle), BackgroundTransparency = 1, ClipsDescendants = false,
	})
	view.ResizeCaps = {}
	local edge = (ResizeStyle.Idle + ResizeStyle.Gap - ResizeStyle.Gutter + ResizeStyle.Thickness / 2) / ResizeStyle.Idle
	for index, position in { UDim2.fromScale(edge, 0), UDim2.fromScale(0, edge) } do
		local cap = create(app, "Frame", "Cap" .. index, ends, Layers.Resize, {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = position, Size = UDim2.fromOffset(ResizeStyle.Thickness, ResizeStyle.Thickness),
			BackgroundColor3 = Color3.new(0.5, 0.5, 0.5), Active = false,
		})
		corner(app, cap, ResizeStyle.Thickness)
		local shade = if index == 1 then 56 else 36
		create(app, "UIGradient", "Graphite", cap, nil, { Color = ColorSequence.new(Color3.fromRGB(shade, shade, shade)) })
		table.insert(view.ResizeCaps :: { Frame }, cap)
	end
	Resources.connect(app._input.Scope, (view.Grip :: TextButton).MouseEnter, function()
		app._input.ResizeHovered = true; Input.resizeVisual(app)
	end)
	Resources.connect(app._input.Scope, (view.Grip :: TextButton).MouseLeave, function()
		app._input.ResizeHovered = false; Input.resizeVisual(app)
	end)
	-- These surfaces belong to the app. External destruction revokes the app,
	-- while control rows/panels retain their narrower owners.
	local surfaces: { Instance } = { view.Canvas :: Frame, view.Content :: ScrollingFrame, view.Panel :: Frame, view.TabStrip :: ScrollingFrame, view.Overlay :: Frame, view.Grip :: TextButton,
		view.SettingsLayer :: TextButton, view.SettingsContent :: ScrollingFrame, view.SearchLayer :: Frame, view.SearchInput :: TextBox,
		view.Footer :: Frame, view.FooterText :: TextLabel }
	for _, object in surfaces do
		Resources.connect(app._scope, object.Destroying, function() app:Destroy() end)
	end
end

-- A finite transition owns its driver, tweens and listeners together. Alpha
-- snapshots retain the latest authored transparency, including edits mid-fade.
type AlphaTarget = { Object: any, Property: string, Base: number, Last: number, Alpha: () -> number }
function Motion.alpha(app: App, object: Instance, property: string, base: number): ()
	local dynamic: any = object
	local properties = app._motion.Alphas[object]
	local target = if properties then properties[property] else nil
	if target then
		target.Base = base
		target.Last = base + (1 - base) * target.Alpha()
		dynamic[property] = target.Last
	else dynamic[property] = base end
end
local function fade(app: App, owner: Scope, roots: { Instance }, seconds: number, done: () -> (), from: number?, to: number?): (() -> (), () -> number)
	local targets: { AlphaTarget } = {}
	local driver = Instance.new("NumberValue")
	driver.Value = from or 1
	local function write(target: AlphaTarget, alpha: number): ()
		target.Last = target.Base + (1 - target.Base) * alpha
		target.Object[target.Property] = target.Last
	end
	local function property(object: Instance, name: string): ()
		local dynamic: any = object
		local target: AlphaTarget = { Object = dynamic, Property = name, Base = dynamic[name], Last = dynamic[name], Alpha = function() return driver.Value end }
		local properties = app._motion.Alphas[object]
		if not properties then properties = {}; app._motion.Alphas[object] = properties end
		properties[name] = target
		table.insert(targets, target)
		Resources.connect(owner, object:GetPropertyChangedSignal(name), function()
			local authored: number = dynamic[name]
			if math.abs(authored - target.Last) < 0.00001 then return end
			target.Base = authored
			write(target, driver.Value)
		end)
		write(target, driver.Value)
	end
	local function collect(object: Instance): ()
		if object:IsA("CanvasGroup") then property(object, "GroupTransparency"); return end
		if object:IsA("GuiObject") then property(object, "BackgroundTransparency") end
		if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
			property(object, "TextTransparency"); property(object, "TextStrokeTransparency")
		end
		if object:IsA("ImageLabel") or object:IsA("ImageButton") then property(object, "ImageTransparency") end
		if object:IsA("UIStroke") then property(object, "Transparency") end
		for _, child in object:GetChildren() do collect(child) end
	end
	-- Registered first so listeners/tweens are disconnected before restoration.
	Resources.add(owner, function()
		for _, target in targets do
			local properties = app._motion.Alphas[target.Object]
			if properties and properties[target.Property] == target then
				properties[target.Property] = nil
				if next(properties) == nil then app._motion.Alphas[target.Object] = nil end
			end
			safe(function() target.Object[target.Property] = target.Base end)
		end
		table.clear(targets); driver:Destroy()
	end)
	for _, root in roots do collect(root) end
	Resources.connect(owner, driver.Changed, function()
		for _, target in targets do write(target, driver.Value) end
	end)
	local tween = game:GetService("TweenService"):Create(driver, TweenInfo.new(seconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Value = to or 0 })
	Resources.tween(owner, tween)
	Resources.connect(owner, tween.Completed, function(state)
		if state == Enum.PlaybackState.Completed then done() end
	end)
	return function() if not owner.Closed then tween:Play() end end, function() return driver.Value end
end
local function motionEnabled(app: App): boolean
	return app:GetAnimationsEnabled() and Gui.showing(app)
end
function Motion.to(app: App, parent: Scope, object: Instance, goals: { [string]: any }, seconds: number, done: (() -> ())?, instant: boolean?): Scope?
	local previous = app._motion.Tracks[object]
	if previous then Resources.close(previous.Scope) end -- preserve displayed properties when retargeting
	local dynamic: any = object
	local different = false
	for name, value in goals do if dynamic[name] ~= value then different = true end end
	if instant or not motionEnabled(app) or not different then
		for name, value in goals do dynamic[name] = value end
		if done then done() end
		return nil
	end
	local owner = scope()
	local track: MotionTrack = { Scope = owner, Object = dynamic, Goals = goals }
	app._motion.Tracks[object] = track
	Resources.own(parent, owner); Resources.own(app._motion.Scope, owner)
	Resources.add(owner, function() if app._motion.Tracks[object] == track then app._motion.Tracks[object] = nil end end)
	local tween = game:GetService("TweenService"):Create(object, TweenInfo.new(seconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
	Resources.tween(owner, tween)
	Resources.connect(owner, tween.Completed, function(state)
		Resources.close(owner)
		if state == Enum.PlaybackState.Completed and done then done() end
	end)
	tween:Play()
	return owner
end
function Motion.popup(app: App, popup: DropdownPopup, closing: boolean): ()
	local alpha = if popup.Alpha then popup.Alpha() else (if closing then 0 else 1)
	if popup.FadeScope then Resources.close(popup.FadeScope) end
	if not motionEnabled(app) then if closing then Resources.close(popup.Scope) end; return end
	local owner = scope()
	popup.FadeScope = owner
	Resources.own(popup.Scope, owner); Resources.own(app._motion.Scope, owner)
	Resources.add(owner, function() if popup.FadeScope == owner then popup.FadeScope, popup.Alpha = nil, nil end end)
	local play, current = fade(app, owner, { popup.Root }, 0.10, function()
		if closing then Resources.close(popup.Scope) else Resources.close(owner) end
	end, alpha, if closing then 1 else 0)
	popup.Alpha = current
	play()
end
function Motion.cancelMenu(app: App): ()
	if app._motion.Menu then Resources.close(app._motion.Menu :: Scope) end
end
function Motion.cancelSections(app: App, settle: boolean?): ()
	app._motion.FinishLayout = settle ~= false
	if app._motion.Sections then Resources.close(app._motion.Sections :: Scope) end
	app._motion.Next = nil
	if settle ~= false then
		for _, record in app._sections.Order do
			record.RevealPending,record.ExitPending,record.HeightPending=false,false,false
			if record.Root then record.Root.Visible=Sections.participates(record) end
			if record.Body then record.Body.Visible=Sections.participates(record) and not Modes.collapsed(record) end
		end
	end
end
function Motion.cancel(app: App): ()
	Motion.cancelMenu(app); Motion.cancelSections(app)
	for _, popup in table.clone(app._motion.Closing) do Resources.close(popup.Scope) end
	local popup = app._interaction.Popup
	if popup and popup.FadeScope then Resources.close(popup.FadeScope) end
	for _, track in table.clone(app._motion.Tracks) do
		for name, value in track.Goals do safe(function() track.Object[name] = value end) end
		Resources.close(track.Scope)
	end
end
function Motion.intro(app: App): ()
	Motion.cancelMenu(app)
	if not app:GetAnimationsEnabled() or not app._life.Visible or not app.Root then return end
	local owner = scope()
	app._motion.Menu = owner
	Resources.own(app._motion.Scope, owner)
	Resources.add(owner, function() if app._motion.Menu == owner then app._motion.Menu = nil end end)
	local roots: { Instance } = { app.Root :: Frame }
	if app.OverlayRoot then table.insert(roots, app.OverlayRoot :: Frame) end
	local play = fade(app, owner, roots, 0.17, function() Resources.close(owner) end)
	play()
end
function Motion.prepare(app: App, kind: string, tab: TabRecord?): ()
	Motion.cancelMenu(app)
	app._motion.Next = if motionEnabled(app) then kind else nil
	if not app._motion.Next then return end
	if kind == "add" then
		for _, record in app._sections.Order do
			if rawequal(record.Tab, tab) and not app._motion.Presented[record.Metadata.Path] then record.RevealPending = true end
		end
	elseif kind == "remove" then
		for _, record in app._sections.Order do
			if rawequal(record.Tab, tab) and record.Root and record.Root.Visible then record.ExitPending = true end
		end
	end
end
function Motion.policy(app: App): ()
	if not app:GetAnimationsEnabled() then
		Motion.cancel(app)
		if app._view.Content then Sections.reflow(app) end
		for _, collection in app._values.BySection do
			for _, record in collection.Order do
				if record.Kind == "Toggle" then Controls.paint(record, true)
				elseif record.Kind == "Slider" then Sliders.paint(record, true) end
			end
		end
	end
	for _, record in app._tabs.Order do Tabs.paint(record, true) end
	Background.visible(app)
end
function Motion.layout(app: App, slots: { SectionSlot }, drag: SectionDrag?): ()
	local motion = app._motion
	local key = tostring(Modes.settingsOpen(app)) .. ":" .. tostring(Modes.filtering(app))
	local previous: { [SectionRecord]: { Position: UDim2, Size: UDim2 } } = {}
	local fresh: { SectionRecord } = {}
	local exits: { SectionRecord } = {}
	for _, record in app._sections.Order do
		if record.Root then previous[record] = { Position = record.Root.Position, Size = record.Root.Size } end
		if record.ExitPending and not Sections.participates(record) then
			table.insert(exits, record)
		end
	end
	for _, slot in slots do
		key ..= "|" .. slot.Record.Metadata.Path .. ":" .. tostring(slot.Position) .. ":" .. tostring(slot.Size)
		if Sections.participates(slot.Record) and not motion.Presented[slot.Record.Metadata.Path] then table.insert(fresh, slot.Record) end
	end
	if motion.Sections and motion.Target == key and not drag then
		motion.Next = nil
		Sections.render(app, slots, drag)
		for record, view in previous do if record.Root then record.Root.Position, record.Root.Size = view.Position, view.Size end end
		return
	end
	local kind = motion.Next or (if motion.Sections then "resize" else nil)
	local animate = kind ~= nil and motionEnabled(app) and not drag
	-- Retargeting preserves actual display coordinates, not the previous goal.
	Motion.cancelSections(app, false)
	motion.Target = key
	Sections.render(app, slots, drag)
	for _, record in app._sections.Order do
		record.RevealPending, record.ExitPending, record.HeightPending = false, false, false
		motion.Presented[record.Metadata.Path] = Sections.participates(record)
		if record.Root then record.Root.Visible = Sections.participates(record) end
		if record.Body then record.Body.Visible = Sections.participates(record) and not Modes.collapsed(record) end
	end
	if not animate then return end
	local owner = scope()
	motion.Sections, motion.FinishLayout = owner, true
	Resources.own(motion.Scope, owner)
	Resources.add(owner, function()
		if motion.Sections == owner then motion.Sections = nil end
		for _, record in app._sections.Order do
			record.RevealPending, record.ExitPending, record.HeightPending = false, false, false
			local visible = Sections.participates(record)
			motion.Presented[record.Metadata.Path] = visible
			if record.Root and not record.Scope.Closed then
				if motion.FinishLayout then
					record.Root.Position = UDim2.fromOffset(record.Position.X,record.Position.Y)
					record.Root.Size = UDim2.fromOffset(record.Size.X,record.Size.Y)
				end
				record.Root.Visible = visible
			end
			if record.Body then record.Body.Visible = visible and not Modes.collapsed(record) end
		end
	end)
	local add = kind == "add" and #fresh > 0 and not Modes.settingsOpen(app) and not Modes.filtering(app)
	local remove = kind == "remove" and #exits > 0
	local playIn: (() -> ())? = nil
	if add then
		local roots: { Instance } = {}
		for _, record in fresh do
			record.RevealPending = true
			if record.Root then record.Root.Visible = false; table.insert(roots,record.Root :: Frame) end
		end
		playIn = fade(app,owner,roots,0.11,function() Resources.close(owner) end)
	end
	-- Keep existing cards at their current positions/heights while any departure
	-- fades. Fixed body/control dimensions are clipped by the card, never scaled.
	for _, slot in slots do
		local record, view, root = slot.Record, previous[slot.Record], slot.Record.Root
		if root and view and Sections.participates(record) and (not add or not table.find(fresh,record)) then
			root.Position, root.Size = view.Position, view.Size
			record.HeightPending = view.Size ~= UDim2.fromOffset(slot.Size.X,slot.Size.Y)
			if record.Body then record.Body.Visible = not Modes.collapsed(record) or record.HeightPending end
		end
	end
	local function afterMove(): ()
		if owner.Closed then return end
		if add then
			for _, record in fresh do if record.Root then record.Root.Visible = Sections.participates(record) end end
			(playIn :: () -> ())()
		else Resources.close(owner) end
	end
	local function move(): ()
		if owner.Closed then return end
		local moving = 0
		local seconds = if kind == "resize" then 0.09 elseif kind == "collapse" then 0.135 else 0.15
		for _, slot in slots do
			local record, root = slot.Record, slot.Record.Root
			local position, size = UDim2.fromOffset(slot.Position.X,slot.Position.Y),UDim2.fromOffset(slot.Size.X,slot.Size.Y)
			if root and Sections.participates(record) and (not add or not table.find(fresh,record)) and (root.Position ~= position or root.Size ~= size) then
				moving += 1
				local tween = game:GetService("TweenService"):Create(root,TweenInfo.new(seconds,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=position,Size=size})
				Resources.tween(owner,tween)
				Resources.connect(owner,tween.Completed,function(state)
					if state ~= Enum.PlaybackState.Completed then return end
					record.HeightPending = false
					if record.Body then record.Body.Visible = Sections.participates(record) and not Modes.collapsed(record) end
					moving -= 1
					if moving == 0 then afterMove() end
				end)
				tween:Play()
			end
		end
		if moving == 0 then afterMove() end
	end
	if remove then
		local roots: { Instance } = {}
		for _, record in exits do
			record.ExitPending = true
			motion.Presented[record.Metadata.Path] = true
			if record.Root then record.Root.Visible = true; table.insert(roots,record.Root :: Frame) end
			if record.Body then record.Body.Visible = not Modes.collapsed(record) end
		end
		local play = fade(app,owner,roots,0.11,function()
			for _, record in exits do
				record.ExitPending = false
				motion.Presented[record.Metadata.Path] = false
				if record.Root then record.Root.Visible = false end
				if record.Body then record.Body.Visible = false end
			end
			move()
		end,0,1)
		play()
	else move() end
end

-- Geometry is independent of tab activation and future control values.
local Layout: LayoutComponent = {} :: any
function Layout.viewport(app: App): Vector2
	-- CoreGui parents can have a smaller canvas than CurrentCamera.ViewportSize.
	-- Bounds use the same local coordinate space as Root.Position and Root.Size.
	local canvas = app._view.Canvas
	local size = if canvas then canvas.AbsoluteSize else Vector2.zero
	if size.X <= 0 or size.Y <= 0 then
		local camera = workspace.CurrentCamera
		size = if camera then camera.ViewportSize else Vector2.zero
	end
	return size
end
function Layout.margin(viewport: Vector2): number
	return math.min(Appearance.Margin, math.max(0, (math.min(viewport.X, viewport.Y) - Appearance.PanelHeight) / 2))
end
function Layout.apply(app: App): ()
	local geometry = app._geometry
	local viewport = Layout.viewport(app)
	if viewport.X <= 0 or viewport.Y <= 0 then return end
	local viewportChanged = viewport ~= geometry.Viewport
	geometry.Viewport = viewport
	-- Margin relaxes on tiny viewports; the panel/icon pixel sizes never scale.
	local margin = Layout.margin(viewport)
	local available = Vector2.new(math.max(1, viewport.X - margin * 2 - ResizeStyle.Gutter), math.max(1, viewport.Y - margin * 2 - ResizeStyle.Gutter))
	geometry.Size = Vector2.new(
		math.clamp(geometry.Size.X, math.min(Appearance.Minimum.X, available.X), available.X),
		math.clamp(geometry.Size.Y, math.min(Appearance.Minimum.Y, available.Y), available.Y)
	)
	local sizeChanged = app.Root ~= nil and app.Root.Size ~= UDim2.fromOffset(geometry.Size.X, geometry.Size.Y)
	if viewportChanged or sizeChanged then Motion.prepare(app,"resize") end
	if not geometry.Initialized then
		geometry.Position = (viewport - geometry.Size) / 2
		geometry.Initialized = true
	end
	geometry.Position = Vector2.new(
		math.clamp(geometry.Position.X, margin, math.max(margin, viewport.X - geometry.Size.X - margin - ResizeStyle.Gutter)),
		math.clamp(geometry.Position.Y, margin, math.max(margin, viewport.Y - geometry.Size.Y - margin - ResizeStyle.Gutter))
	)
	if app._view.Root then
		app._view.Root.Position = UDim2.fromOffset(geometry.Position.X, geometry.Position.Y)
		app._view.Root.Size = UDim2.fromOffset(geometry.Size.X, geometry.Size.Y)
	end
	if app._view.Grip then
		app._view.Grip.Position = UDim2.fromOffset(geometry.Position.X + geometry.Size.X + ResizeStyle.Gutter, geometry.Position.Y + geometry.Size.Y + ResizeStyle.Gutter)
	end
	if viewportChanged or sizeChanged then Tabs.arrange(app); Sections.request(app) end
end
-- Tabs own metadata, independent activation, hover and per-icon resources.
-- Activation selects sections; section collapse and future Flags have separate owners.
function Tabs.paint(record: TabRecord, instant: boolean?): ()
	if record.Scope.Closed then return end
	if record.Button then record.Button.BackgroundTransparency = 1 end
	if record.Visual then record.Visual.BackgroundTransparency = 1 end
	if record.Image then
		record.Image.BackgroundTransparency = 1
		record.Image.ImageColor3 = if record.Active then Colors.accent(record.Owner) else Appearance.IdleIcon
	end
	if record.Indicator then record.Indicator.Visible = record.Active; record.Indicator.BackgroundColor3 = Colors.accent(record.Owner) end
	local image, app = record.Image, record.Owner
	if not image then return end
	local showing = app._life.Phase == "ready" and app._life.Visible
		and app.Root ~= nil and (app.Root :: Frame).Visible and app.ScreenGui ~= nil and (app.ScreenGui :: ScreenGui).Enabled
	local animate = not instant and showing and app:GetAnimationsEnabled()
	if not animate then record.Pressed, record.Returning = false, false end
	local hovered = showing and record.Hovered
	local scale = if record.Pressed then 0.92 elseif hovered then Appearance.TabHoverScale else 1
	if animate and record.GoalScale == scale then return end
	if record.PaintScope then Resources.close(record.PaintScope) end
	record.GoalScale = scale
	local relative = Appearance.IconSize / Appearance.ButtonSize * scale
	local size = UDim2.fromScale(relative, relative)
	if not animate then image.Size = size; return end
	-- Only the centred icon changes size. The transparent container, dot,
	-- UIListLayout and hit area stay fixed. Completion never repaints state.
	local owned = scope()
	record.PaintScope = owned
	Resources.own(record.Scope, owned)
	Resources.own(app._motion.Scope, owned)
	local tween: Tween? = nil
	Resources.add(owned, function()
		if record.PaintScope == owned then record.PaintScope = nil end
		if tween then safe(function() (tween :: Tween):Cancel() end); safe(function() (tween :: Tween):Destroy() end) end
	end)
	local ok, problem = protected(function()
		local seconds = if record.Pressed then 0.07 elseif record.Returning then 0.10 else Appearance.TabTweenTime
		tween = game:GetService("TweenService"):Create(image, TweenInfo.new(seconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = size,
		})
		local playing = tween :: Tween
		Resources.connect(owned, playing.Completed, function(state)
			Resources.close(owned)
			if state ~= Enum.PlaybackState.Completed or record.Scope.Closed then return end
			if record.Pressed then
				record.Pressed, record.Returning, record.GoalScale = false, true, nil
				Tabs.paint(record)
			else record.Returning = false end
		end)
		playing:Play()
	end)
	if not ok then
		Resources.close(owned)
		image.Size = size
		diagnostic("tab paint: " .. tostring(problem))
	end
end
function Tabs.press(record: TabRecord): ()
	if record.Scope.Closed or not motionEnabled(record.Owner) then return end
	-- Force a fresh pulse even if a repeated click hits the same down goal.
	record.Pressed, record.Returning, record.GoalScale = true, false, nil
	Tabs.paint(record)
end
function Tabs.clearHover(app: App): ()
	for _, record in app._tabs.Order do record.Hovered = false; Tabs.paint(record, true) end
end
function Tab.IsActive(self: TabInternal): boolean return self._record.Active end
function Tab.GetMetadata(self: TabInternal): { Id: string, Name: string, Icon: string } return self._record.Metadata end
function Tab.GetButton(self: TabInternal): ImageButton? return self._record.Button end
function Tab.GetStatus(self: TabInternal): { Active: boolean, Hovered: boolean, IconOutcome: string, Destroyed: boolean }
	local record = self._record
	return { Active = record.Active, Hovered = record.Hovered, IconOutcome = record.Outcome,
		Destroyed = record.Scope.Closed }
end
function Tab.SetActive(self: TabInternal, active: boolean): ()
	assert(type(active) == "boolean", "SetActive expects boolean")
	local record = self._record
	local app = record.Owner
	if record.Scope.Closed then return end
	if record == app._tabs.Search then Modes.search(app, active); return end
	if record == app._tabs.Settings then Modes.settings(app, active); return end
	if Modes.settingsOpen(app) then Modes.settings(app, false) end
	if not alive(app) or record.Scope.Closed or record.Active == active then return end
	Sections.cancelDrag(record.Owner)
	Motion.prepare(app, if active then "add" else "remove", record)
	record.Active = active
	Sections.visibility(record.Owner, record)
	Tabs.paint(record)
	Sections.request(record.Owner)
	if record.Callback and not app._preferences.Restoring then
		local ok, problem = protected(record.Callback, active, record.Metadata.Id)
		if not ok then diagnostic("tab " .. record.Metadata.Id .. " callback: " .. tostring(problem)) end
	end
end
function Tab.IsDestroyed(self: TabInternal): boolean return self._record.Scope.Closed end
function Tab.Destroy(self: TabInternal): ()
	local record, app = self._record, self._record.Owner
	if record.Scope.Closed then return end
	-- Utility surfaces are essential to the window's mode contract.
	if record == app._tabs.Search or record == app._tabs.Settings then app:Destroy(); return end
	Sections.cancelDrag(app)
	Resources.close(record.Scope)
	if alive(app) then Tabs.arrange(app); Modes.invalidate(app) end
end
function Tabs.arrange(app: App): ()
	local count, search, settings = 0, app._tabs.Search, app._tabs.Settings
	for _, record in app._tabs.Order do
		if not rawequal(record, search) and not rawequal(record, settings) then
			count += 1
			if record.Button then record.Button.LayoutOrder = count * 2 end
		end
	end
	local divider, slot = app._view.TabDivider, app._view.TabDividerSlot
	if slot then slot.Visible = count > 0; slot.LayoutOrder = count * 2 + 1 end
	if divider then divider.Visible = count > 0; divider.LayoutOrder = count * 2 + 1 end
	if search and search.Button then search.Button.LayoutOrder = count * 2 + 2 end
	if settings and settings.Button then settings.Button.LayoutOrder = count * 2 + 4 end
	local width = (count + 2) * Appearance.ButtonSize + Appearance.ButtonGap
	if count > 0 then width += Appearance.TabDividerSlot + (count + 1) * Appearance.ButtonGap end
	local strip, group = app._view.TabStrip, app._view.TabGroup
	if not strip or not group then return end
	local available = math.max(1, app._geometry.Size.X - Appearance.ContentPadding * 2)
	local visibleWidth = math.min(width, available)
	group.Size = UDim2.fromOffset(width, Appearance.PanelHeight)
	strip.Size = UDim2.fromOffset(visibleWidth, Appearance.PanelHeight)
	strip.CanvasSize = UDim2.fromOffset(width, Appearance.PanelHeight)
	strip.ScrollingEnabled = width > available
	strip.Active = width > available
	strip.CanvasPosition = Vector2.new(math.clamp(strip.CanvasPosition.X, 0, math.max(0, width - visibleWidth)), 0)
end
function Tabs.mount(app: App, record: TabRecord): ()
	if record.Button or record.Scope.Closed then return end
	local group = app._view.TabGroup :: Frame
	local button = create(app, "ImageButton", record.Metadata.Id, group, Layers.Panel, {
		Size = UDim2.fromOffset(Appearance.ButtonSize, Appearance.ButtonSize),
		BackgroundTransparency = 1, AutoButtonColor = false, Image = "", Active = true,
		LayoutOrder = #group:GetChildren(), Selectable = false, ClipsDescendants = false,
	}, record.Scope)
	record.Button = button
	local visual: Frame = create(app, "Frame", "Visual", button, Layers.Panel, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, Active = false, Selectable = false,
	}, record.Scope)
	record.Visual = visual
	record.Image = create(app, "ImageLabel", "Icon", visual, Layers.Panel, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -1),
		Size = UDim2.fromScale(Appearance.IconSize / Appearance.ButtonSize, Appearance.IconSize / Appearance.ButtonSize), BackgroundTransparency = 1,
		ImageColor3 = Appearance.White, ScaleType = Enum.ScaleType.Fit,
		Active = false, Selectable = false,
	}, record.Scope)
	record.Indicator = create(app, "Frame", "ActiveDot", visual, Layers.Panel, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 1, -1),
		Size = UDim2.fromOffset(3, 3), BackgroundColor3 = Appearance.TabActiveIcon, Visible = record.Active,
		Active = false, Selectable = false,
	}, record.Scope)
	create(app, "UICorner", "Corner", record.Indicator, nil, { CornerRadius = UDim.new(0.5, 0) }, record.Scope)
	record.Fallback = create(app, "Frame", "IconFallback", visual, Layers.Panel, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(10 / Appearance.ButtonSize, 10 / Appearance.ButtonSize), BackgroundColor3 = Appearance.IdleIcon,
		Visible = false, Active = false, Selectable = false,
	}, record.Scope)
	Resources.connect(record.Scope, button.MouseEnter, function()
		if not Gui.showing(app) then return end
		record.Hovered = true; Tabs.paint(record)
	end)
	Resources.connect(record.Scope, button.MouseLeave, function() record.Hovered = false; Tabs.paint(record) end)
	Resources.connect(record.Scope, button.Activated, function()
		if Gui.showing(app) and not app._motion.Menu and not app._interaction.Assignment and not app._interaction.ConsumedPointer and record.Outcome ~= "pending" then
			local handle = record.Handle :: TabHandle
			local active = not record.Active
			handle:SetActive(active)
			Tabs.press(record)
		end
	end)
	Resources.connect(record.Scope, button.Destroying, function() if not record.Scope.Closed and alive(app) then (record.Handle :: TabHandle):Destroy() end end)
	Resources.connect(record.Scope, visual.Destroying, function() if not record.Scope.Closed and alive(app) then (record.Handle :: TabHandle):Destroy() end end)
	Tabs.arrange(app)
	Tabs.paint(record)
end
-- One bounded job and one decoded asset per canonical source, per app.
-- Each waiter has a detachable subscription; native HTTP cannot outlive rights.
function Icons.load(app: App, source: string, owner: Scope, label: string): (string?, string)
	if not alive(app) or owner.Closed then return nil, "cancelled" end
	local icons, stats = app._icons, app._icons.Stats
	local cached = icons.Cache[source]
	if cached then stats.MemoryHits += 1; return cached, "memory" end
	local work: IconJob? = icons.Jobs[source]
	if not work then
		local deadline = os.clock() + app._life.IconTimeout
		if app._life.Phase == "loading" then deadline = math.min(deadline, app._life.Deadline) end
		local currentWork: IconJob = { Scope = scope(), Deadline = deadline, Consumers = 0, Done = false, Outcome = "pending" }
		work = currentWork
		icons.Jobs[source] = currentWork
		stats.Pending += 1; stats.WorkerStarts += 1
		Resources.own(icons.Scope, currentWork.Scope)
		Resources.add(currentWork.Scope, function()
			currentWork.Done = true
			if currentWork.Outcome == "pending" then currentWork.Outcome = "cancelled" end
			if icons.Jobs[source] == currentWork then icons.Jobs[source] = nil end
			stats.Pending -= 1
		end)
		local function current(): boolean
			return alive(app) and not currentWork.Scope.Closed and currentWork.Consumers > 0 and os.clock() < currentWork.Deadline
		end
		Resources.spawn(currentWork.Scope, function()
			local ok, asset, outcome = protected(Icons.resolve, app, source, current)
			if not current() then return end
			currentWork.Asset = if ok then asset else nil
			currentWork.Outcome = if currentWork.Asset then outcome else "fallback"
			if currentWork.Asset then icons.Cache[source] = currentWork.Asset else
				stats.Failures += 1
				diagnostic(label .. ": " .. tostring(if ok then "icon unavailable" else asset))
			end
			Resources.close(currentWork.Scope)
		end)
	end
	local shared = work :: IconJob
	shared.Consumers += 1
	local subscribed = true
	local function unsubscribe()
		if not subscribed then return end
		subscribed = false; shared.Consumers -= 1
		if shared.Consumers == 0 and not shared.Done then Resources.close(shared.Scope) end
	end
	local detach = Resources.add(owner, unsubscribe)
	while alive(app) and not owner.Closed and not shared.Done and os.clock() < shared.Deadline do task.wait() end
	if not shared.Done and os.clock() >= shared.Deadline then
		shared.Outcome = "fallback"; stats.Failures += 1
		diagnostic(label .. ": icon deadline exceeded")
		Resources.close(shared.Scope)
	end
	unsubscribe(); detach()
	if not alive(app) or owner.Closed then return nil, "cancelled" end
	return shared.Asset, shared.Outcome
end
function Tabs.load(app: App, record: TabRecord): ()
	if record.Scope.Closed or not alive(app) or record.Outcome ~= "pending" then return end
	local asset, outcome = Icons.load(app, record.Metadata.Icon, record.Scope, "tab " .. record.Metadata.Id)
	if not alive(app) or record.Scope.Closed then return end
	record.Asset, record.Outcome = asset, outcome
	if record.Image then record.Image.Image = asset or ""; record.Image.Visible = asset ~= nil end
	if record.Fallback then record.Fallback.Visible = asset == nil end
	Sections.refreshIcons(app)
end
function Application.AddTab(self: App, options: TabOptions): TabHandle
	assert(alive(self), "Cannot add a tab to a destroyed menu")
	Tabs.validate(options)
	assert(self._tabs.ById[options.Id] == nil, "Duplicate tab Id: " .. options.Id)
	local record: TabRecord = {
		Metadata = table.freeze({ Id = options.Id, Name = options.Name, Icon = Icons.source(options.Icon) }),
		Active = options.Active == true, Hovered = false, Pressed = false, Returning = false, TitleWidth = 0, Callback = options.Callback, Scope = scope(), Outcome = "pending", Owner = self,
	}
	record.TitleWidth = (game:GetService("TextService") :: TextService):GetTextSize(options.Name, Appearance.SectionTitleSize, Enum.Font.JosefinSans, Vector2.new(10000, Appearance.SectionHeader)).X
	self._metrics.TextMeasurements += 1
	local handle: TabInternal = table.freeze(setmetatable({ _record = record }, Tab)) :: any
	record.Handle = handle
	self._tabs.ById[record.Metadata.Id] = record
	table.insert(self._tabs.Order, record)
	Resources.own(self._scope, record.Scope)
	Resources.add(record.Scope, function()
		local collection = self._sections.ByTab[record.Metadata.Id]
		if collection then
			local sections = table.clone(collection.Order)
			for _, section in sections do if section.Handle then section.Handle:Destroy() end end
		end
		self._sections.ByTab[record.Metadata.Id] = nil
		if self._tabs.ById[record.Metadata.Id] == record then self._tabs.ById[record.Metadata.Id] = nil end
		local index = table.find(self._tabs.Order, record); if index then table.remove(self._tabs.Order, index) end
		record.Asset, record.Callback, record.Button, record.Image, record.Indicator, record.Fallback, record.Visual = nil, nil, nil, nil, nil, nil, nil
		record.PaintScope, record.GoalScale = nil, nil
		if alive(self) then Tabs.arrange(self); Modes.invalidate(self) end
	end)
	if self._view.TabGroup then
		local ok, problem = protected(Tabs.mount, self, record)
		if not ok then Resources.close(record.Scope); Tabs.arrange(self); error("Tab construction: " .. tostring(problem), 0) end
	end
	if self._life.Phase == "ready" then Resources.spawn(record.Scope, function() Tabs.load(self, record) end) end
	return handle
end
function Application.GetTab(self: App, id: string): TabHandle?
	local record = self._tabs.ById[id]
	return if record then record.Handle else nil
end

-- Persistent order belongs to the common area. Drag uses a separate transaction.
function Sections.request(app: App): ()
	local area = app._sections
	if not alive(app) or area.Scope.Closed or area.Queued then return end
	area.Queued = true
	Resources.spawn(area.Scope, function()
		area.Queued = false
		if not alive(app) then return end
		local ok, problem = protected(Sections.reflow, app)
		if not ok then app:_fail("section layout: " .. tostring(problem)) end
	end)
end
local function releaseBodyFocus(record: SectionRecord): ()
	local focused = record.Owner._env.Input:GetFocusedTextBox()
	if focused and record.Body and focused:IsDescendantOf(record.Body) then focused:ReleaseFocus(false) end
end
function Sections.refreshIcons(app: App): ()
	for _, record in app._sections.Order do
		if record.TabIcon then record.TabIcon.Image = record.Tab.Asset or ""; record.TabIcon.Visible = record.Tab.Asset ~= nil end
		if record.DragIcon then record.DragIcon.Image = app._sections.DragAsset or "" end
		if record.Chevron then record.Chevron.Image = app._sections.CollapseAsset or "" end
	end
end
function Sections.loadHeaderIcons(app: App): ()
	local area = app._sections
	if area.HeaderIconsStarted or #area.Order == 0 or not alive(app) then return end
	area.HeaderIconsStarted = true
	local asset, outcome = Icons.load(app, Icons.source(SECTION_DRAG_ICON), area.Scope, "section drag icon")
	if not alive(app) or area.Scope.Closed then return end
	area.DragAsset, area.DragIconOutcome = asset, outcome
	if not asset then app:_fail("required section drag icon unavailable: " .. SECTION_DRAG_ICON); return end
	local collapseAsset, collapseOutcome = Icons.load(app, Icons.source(SECTION_COLLAPSE_ICON), area.Scope, "section collapse icon")
	if not alive(app) or area.Scope.Closed then return end
	area.CollapseAsset, area.CollapseIconOutcome = collapseAsset, collapseOutcome
	if not collapseAsset then app:_fail("required section collapse icon unavailable: " .. SECTION_COLLAPSE_ICON); return end
	Sections.refreshIcons(app)
end
function Sections.visibility(app: App, tab: TabRecord): ()
	local collection = app._sections.ByTab[tab.Metadata.Id]
	if not collection then return end
	for _, record in collection.Order do
		local visible = Sections.participates(record)
		if record.Root then record.Root.Visible = (visible or record.ExitPending) and not record.RevealPending end
		if record.Body then record.Body.Visible = (visible or record.ExitPending) and (not Modes.collapsed(record) or record.HeightPending) end
		if not Sections.interactive(record) then releaseBodyFocus(record); Controls.cancel(app, record) end
	end
end
function Sections.registrationOrder(app: App): { SectionRecord }
	local result: { SectionRecord } = {}
	local maximum = 0
	for _, tab in app._tabs.Order do
		local collection = app._sections.ByTab[tab.Metadata.Id]
		if collection then maximum = math.max(maximum, #collection.Order) end
	end
	for ordinal = 1, maximum do
		for _, tab in app._tabs.Order do
			local collection = app._sections.ByTab[tab.Metadata.Id]
			local record = if collection then collection.Order[ordinal] else nil
			if record and not record.Scope.Closed then table.insert(result, record) end
		end
	end
	return result
end
function Sections.container(app: App, tab: TabRecord?): ScrollingFrame?
	local settings = if tab then tab == app._tabs.Settings else Modes.settingsOpen(app)
	return if settings then app._view.SettingsContent else app._view.Content
end
function Sections.participates(record: SectionRecord): boolean
	if record.Scope.Closed then return false end
	local app, tab = record.Owner, record.Tab
	if tab == app._tabs.Settings then return tab.Active end
	if tab == app._tabs.Search then return false end
	if Modes.filtering(app) then return app._search.Sections[record.Metadata.Path] == true end
	return tab.Active
end
function Sections.interactive(record: SectionRecord): boolean
	local app = record.Owner
	return Gui.showing(app) and Sections.participates(record)
		and not app._motion.Menu and not record.RevealPending and not record.ExitPending
		and (Modes.settingsOpen(app) == (rawequal(record.Tab, app._tabs.Settings)))
end
function Sections.ordered(app: App, settings: boolean?): { SectionRecord }
	local result: { SectionRecord } = {}
	for _, record in app._sections.Order do
		if settings then
			if rawequal(record.Tab, app._tabs.Settings) and not record.Scope.Closed then table.insert(result, record) end
		elseif not rawequal(record.Tab, app._tabs.Settings) and Sections.participates(record) then table.insert(result, record) end
	end
	return result
end
function Sections.plan(app: App, ordered: { SectionRecord }, target: ScrollingFrame?): ({ SectionSlot }, number, number)
	local scroll = target or app._view.Content
	-- The invisible scrollbar reserves no pixels, independent of canvas height.
	-- Measure the scrolling viewport once, then apply the two content insets.
	local width = if scroll and scroll.AbsoluteSize.X > 0 then scroll.AbsoluteSize.X else app._geometry.Size.X
	local window = if scroll and scroll.AbsoluteWindowSize.X > 0 then scroll.AbsoluteWindowSize.X else width
	local reservedWindow = math.min(window, width)
	local usable = math.max(1, reservedWindow - Appearance.ContentPadding - Appearance.ContentRightPadding)
	local columns = math.clamp(math.floor((usable + Appearance.ContentGap) / (Appearance.CardWidth + Appearance.ContentGap)), 1, 5)
	local flows: { number } = {}
	for column = 1, columns do flows[column] = Appearance.ContentPadding end
	local slots: { SectionSlot } = {}
	for index, record in ordered do
		local column = (index - 1) % columns + 1
		local bodyHeight = if record.ContentLayout then math.ceil(record.ContentLayout.AbsoluteContentSize.Y) else 0
		local height = Appearance.SectionHeader + (if Modes.collapsed(record) then 0 else bodyHeight + 16)
		local position = Vector2.new(Appearance.ContentPadding + (column - 1) * (Appearance.CardWidth + Appearance.ContentGap), flows[column])
		local slot: SectionSlot = { Record = record, Column = column, Position = position, Size = Vector2.new(Appearance.CardWidth, height) }
		table.insert(slots, slot)
		flows[column] += height + Appearance.ContentGap
	end
	local bottom = 0
	if #ordered > 0 then for _, flow in flows do bottom = math.max(bottom, flow) end end
	return slots, columns, bottom
end
function Sections.reflow(app: App): ()
	local area, scroll = app._sections, app._view.Content
	if area.Scope.Closed or not scroll then return end
	Modes.refresh(app)
	app._metrics.LayoutPasses += 1
	local drag = area.Drag
	local mainDrag = if drag and drag.Record.Tab ~= app._tabs.Settings then drag else nil
	local settingsDrag = if drag and drag.Record.Tab == app._tabs.Settings then drag else nil
	local ordered = if mainDrag and mainDrag.Valid then mainDrag.PreviewOrder else Sections.ordered(app)
	local slots, columns, bottom = Sections.plan(app, ordered)
	area.Columns, area.CardWidth, area.CanvasHeight = columns, Appearance.CardWidth, bottom
	for _, record in area.Order do
		local visible = Sections.participates(record)
		if record.Root then record.Root.Visible = (visible or record.ExitPending) and not record.RevealPending end
		if record.Body then record.Body.Visible = (visible or record.ExitPending) and (not Modes.collapsed(record) or record.HeightPending) end
		if not Sections.interactive(record) or Modes.collapsed(record) then releaseBodyFocus(record); Controls.cancel(app, record) end
	end
	if drag then drag.Placeholder.Visible = drag.Valid end
	scroll.CanvasSize = UDim2.fromOffset(0, bottom)
	local desired = if not Modes.filtering(app) and app._search.RestoreScroll then app._search.RestoreScroll else scroll.CanvasPosition
	scroll.CanvasPosition = Vector2.new(0, math.clamp((desired :: Vector2).Y, 0, math.max(0, bottom - scroll.AbsoluteWindowSize.Y)))
	local settingsScroll = app._view.SettingsContent
	if settingsScroll then
		local settingsOrder = if settingsDrag and settingsDrag.Valid then settingsDrag.PreviewOrder else Sections.ordered(app, true)
		local settingsSlots, settingsColumns, settingsBottom = Sections.plan(app, settingsOrder, settingsScroll)
		app._settings.Columns, app._settings.CanvasHeight = settingsColumns, settingsBottom
		for _, slot in settingsSlots do table.insert(slots,slot) end
		settingsScroll.CanvasSize = UDim2.fromOffset(0, settingsBottom)
		settingsScroll.CanvasPosition = Vector2.new(0, math.clamp(settingsScroll.CanvasPosition.Y, 0, math.max(0, settingsBottom - settingsScroll.AbsoluteWindowSize.Y)))
	end
	Motion.layout(app, slots, mainDrag or settingsDrag)
	Modes.paint(app)
end
function Sections.render(app: App, slots: { SectionSlot }, drag: SectionDrag?): ()
	for _, slot in slots do
		local record = slot.Record
		record.Column, record.Position, record.Size = slot.Column, slot.Position, slot.Size
		local root = record.Root
		if root then
			root.Size = UDim2.fromOffset(slot.Size.X, slot.Size.Y)
			if not drag or not rawequal(drag.Record, record) then root.Position = UDim2.fromOffset(slot.Position.X, slot.Position.Y)
			elseif drag.Valid then
				drag.Placeholder.Position = UDim2.fromOffset(slot.Position.X, slot.Position.Y)
				drag.Placeholder.Size = UDim2.fromOffset(slot.Size.X, slot.Size.Y)
			end
		end
		local bodyHeight = if record.ContentLayout then math.ceil(record.ContentLayout.AbsoluteContentSize.Y) else 0
		if record.Body then record.Body.Size = UDim2.new(1, -Appearance.SectionPadding * 2, 0, bodyHeight) end
	end
end
local function withinSectionArea(app: App, point: Vector2): boolean
	local scroll = Sections.container(app)
	if not scroll then return false end
	local at, size = scroll.AbsolutePosition, scroll.AbsoluteWindowSize
	local grip = app._view.Grip
	if grip then
		local gp, gs = grip.AbsolutePosition, grip.AbsoluteSize
		if point.X >= gp.X and point.Y >= gp.Y and point.X <= gp.X + gs.X and point.Y <= gp.Y + gs.Y then return false end
	end
	return point.X >= at.X and point.Y >= at.Y and point.X < at.X + size.X and point.Y < at.Y + size.Y
end
function Sections.moveDrag(app: App, point: Vector2): ()
	local drag, scroll, overlay = app._sections.Drag, Sections.container(app), app._view.Overlay
	if not drag or not scroll or not overlay or not drag.Record.Root then return end
	drag.Point = point
	local at = point - drag.Offset
	drag.Record.Root.Position = UDim2.fromOffset(at.X - overlay.AbsolutePosition.X, at.Y - overlay.AbsolutePosition.Y)
	drag.Valid, drag.PendingIndex = withinSectionArea(app, point), nil
	if drag.Valid then
		local slots = Sections.plan(app, drag.SourceOrder, scroll)
		local target = at + Vector2.new(Appearance.CardWidth / 2, Appearance.SectionHeader / 2)
		local nearest, distance = 1, math.huge
		for index, slot in slots do
			local center = scroll.AbsolutePosition - scroll.CanvasPosition + slot.Position
				+ Vector2.new(Appearance.CardWidth / 2, Appearance.SectionHeader / 2)
			local delta = center - target
			local square = delta:Dot(delta)
			if square < distance then nearest, distance = index, square end
		end
		local preview: { SectionRecord } = {}
		for _, record in drag.SourceOrder do if not rawequal(record, drag.Record) then table.insert(preview, record) end end
		table.insert(preview, nearest, drag.Record)
		drag.PendingIndex, drag.PreviewOrder = nearest, preview
	end
	Sections.reflow(app)
end
function Sections.endDrag(app: App, commit: boolean): ()
	local area = app._sections
	local drag = area.Drag
	if not drag then return end
	area.Drag = nil -- revoke before parenting/Destroying callbacks
	if commit and drag.Valid and drag.PendingIndex and alive(app) then
		local participants: { [SectionRecord]: boolean } = {}
		for _, record in drag.SourceOrder do participants[record] = true end
		local merged: { SectionRecord } = {}
		local nextIndex = 1
		for _, record in area.Order do
			if participants[record] then
				table.insert(merged, drag.PreviewOrder[nextIndex]); nextIndex += 1
			else table.insert(merged, record) end
		end
		area.Order, area.Reordered = merged, true
	end
	local root = drag.Record.Root
	if root and not drag.Record.Scope.Closed then
		safe(function()
			root.Parent, root.ZIndex = Sections.container(app, drag.Record.Tab), Layers.Content
			root.Position = UDim2.fromOffset(drag.Record.Position.X, drag.Record.Position.Y)
		end)
	end
	Resources.close(drag.Scope)
	if alive(app) then Sections.reflow(app) end
end
function Sections.cancelDrag(app: App) Sections.endDrag(app, false) end
function Sections.beginDrag(app: App, record: SectionRecord, event: InputObject): ()
	if app._interaction.Surface then return end
	local area = app._sections
	if app._life.Phase ~= "ready" or not app._life.Visible or area.Drag or app._input.Gesture
		or app._interaction.Assignment or app._interaction.ConsumedPointer == event
		or not Sections.interactive(record) or not record.Root or not app._view.Overlay then return end
	-- Search preserves the persistent common order. Its filtered projection has
	-- no drop transaction; Settings can use the normal section builder/reorder.
	if not rawequal(record.Tab, app._tabs.Settings) and Modes.filtering(app) then return end
	if event.UserInputType ~= Enum.UserInputType.MouseButton1 and event.UserInputType ~= Enum.UserInputType.Touch then return end
	Mini.closeBranch(app, 1)
	Controls.cancel(app)
	Motion.cancel(app)
	Sections.reflow(app)
	local at = Vector2.new(event.Position.X, event.Position.Y)
	local owned = scope()
	local placeholder = create(app, "Frame", "SectionDropSlot", Sections.container(app, record.Tab), Layers.Content, {
		BackgroundTransparency = 1, Size = UDim2.fromOffset(record.Size.X, record.Size.Y),
	}, owned) :: Frame
	corner(app, placeholder, 6, owned)
	stroke(app, placeholder, Appearance.CardOutline, owned)
	local original = Sections.ordered(app, rawequal(record.Tab, app._tabs.Settings))
	area.Drag = { Record = record, Pointer = event, Scope = owned, Placeholder = placeholder,
		SourceOrder = original, PreviewOrder = table.clone(original), Offset = at - record.Root.AbsolutePosition,
		Point = at, Valid = true }
	record.Root.Parent, record.Root.ZIndex = app._view.Overlay, Layers.SectionDrag
	Sections.moveDrag(app, at)
end
function Section.GetMetadata(self: SectionInternal): HostMetadata return self._record.Metadata end
function Section.IsCollapsed(self: SectionInternal): boolean return self._record.Collapsed end
function Section.GetContent(self: SectionInternal): Frame
	assert(not self._record.Scope.Closed and self._record.Body, "Section is destroyed")
	return self._record.Body :: Frame
end
function Section.GetHeader(self: SectionInternal): Frame? return self._record.Header end
function Section.GetDragHandle(self: SectionInternal): ImageButton? return self._record.DragHandle end
function Section.GetStatus(self: SectionInternal): SectionStatus
	local record = self._record
	return { Collapsed = record.Collapsed, Destroyed = record.Scope.Closed,
		Participating = Sections.participates(record),
		Column = record.Column, Position = record.Position, Size = record.Size,
		Dragging = record.Owner._sections.Drag ~= nil and (record.Owner._sections.Drag :: SectionDrag).Record == record,
		ContentVisible = record.Body ~= nil and (record.Body :: Frame).Visible }
end
function Section.SetCollapsed(self: SectionInternal, collapsed: boolean): ()
	assert(type(collapsed) == "boolean", "SetCollapsed expects boolean")
	local record = self._record
	if record.Scope.Closed or record.Collapsed == collapsed then return end
	Sections.cancelDrag(record.Owner)
	Motion.prepare(record.Owner,"collapse")
	Controls.cancel(record.Owner, record)
	record.Collapsed = collapsed
	record.HeightPending = motionEnabled(record.Owner) and record.Root ~= nil and record.Root.Visible
	if collapsed then releaseBodyFocus(record) end
	if record.Body then record.Body.Visible = Sections.participates(record) and (not Modes.collapsed(record) or record.HeightPending) end
	Sections.request(record.Owner)
end
function Section.Destroy(self: SectionInternal): ()
	local record = self._record
	if record.Scope.Closed or record.Destroying then return end
	record.Destroying = true
	Sections.cancelDrag(record.Owner)
	Motion.cancelSections(record.Owner)
	record.Owner._motion.Presented[record.Metadata.Path] = nil
	Controls.destroySection(record)
	Resources.close(record.Scope)
	local area = record.Owner._sections
	local collection = area.ByTab[record.Metadata.TabId]
	if collection then
		collection.ById[record.Metadata.Id] = nil
		local index = table.find(collection.Order, record)
		if index then table.remove(collection.Order, index) end
	end
	local index = table.find(area.Order, record)
	if index then table.remove(area.Order, index) end
	record.Owner._search.Collapsed[record.Metadata.Path] = nil
	Modes.invalidate(record.Owner)
end
function Sections.build(app: App, record: SectionRecord): ()
	local owned = record.Scope
	Resources.add(owned, function()
		record.Root, record.Header, record.Body, record.ContentLayout = nil, nil, nil, nil
		record.TitleButton, record.TabIcon, record.TabLabel, record.Separator, record.NameLabel, record.Chevron = nil, nil, nil, nil, nil, nil
		record.DragHandle, record.DragIcon, record.CollapseHandle = nil, nil, nil
	end)
	record.Root = create(app, "Frame", record.Metadata.TabId .. "_" .. record.Metadata.Id, Sections.container(app, record.Tab), Layers.Content, {
		BackgroundColor3 = Appearance.Card, Visible = record.Tab.Active,
		ClipsDescendants = true, Size = UDim2.fromOffset(Appearance.CardWidth, Appearance.SectionHeader),
	}, owned)
	corner(app, record.Root :: Frame, 6, owned)
	stroke(app, record.Root :: Frame, Appearance.CardOutline, owned)
	record.Header = create(app, "Frame", "Header", record.Root, Layers.Content, {
		Size = UDim2.new(1, 0, 0, Appearance.SectionHeader), BackgroundTransparency = 1,
	}, owned)
	record.TitleButton = create(app, "TextButton", "Title", record.Header, Layers.Content, {
		Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Selectable = false,
	}, owned)
	record.TabIcon = create(app, "ImageLabel", "TabIcon", record.TitleButton, Layers.Content, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(Appearance.SectionIconCenter.X, Appearance.SectionIconCenter.Y),
		Size = UDim2.fromScale((if rawequal(record.Tab, app._tabs.Settings) then Appearance.SettingsSectionIconSize else Appearance.SectionIconSize) / (Appearance.CardWidth - 60), (if rawequal(record.Tab, app._tabs.Settings) then Appearance.SettingsSectionIconSize else Appearance.SectionIconSize) / Appearance.SectionHeader),
		BackgroundTransparency = 1, Image = record.Tab.Asset or "", ImageColor3 = Appearance.MutedText,
		ScaleType = Enum.ScaleType.Fit, Visible = record.Tab.Asset ~= nil,
	}, owned)
	-- Measure each tab once in its regular Josefin Sans font, keeping the shared
	-- baseline and enough space for the section name before the action hit areas.
	local tabWidth = math.min(math.ceil(record.Tab.TitleWidth), Appearance.SectionTabMaxWidth)
	local separatorX = Appearance.SectionTextStart + tabWidth + Appearance.SectionTitleGap
	local nameX = separatorX + 1 + Appearance.SectionTitleGap
	local function title(name: string, text: string, color: Color3, x: number, width: number): TextLabel
		return create(app, "TextLabel", name, record.TitleButton, Layers.Content, {
			Position = UDim2.fromOffset(x, 0), Size = UDim2.fromOffset(width, Appearance.SectionHeader),
			BackgroundTransparency = 1, Text = text, TextColor3 = color, TextSize = Appearance.SectionTitleSize, FontFace = REGULAR_FACE,
			TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, TextWrapped = false,
		}, owned)
	end
	record.TabLabel = title("TabName", record.Tab.Metadata.Name, Appearance.MutedText, Appearance.SectionTextStart, tabWidth)
	record.Separator = create(app, "Frame", "Separator", record.TitleButton, Layers.Content, {
		Position = UDim2.fromOffset(separatorX, (Appearance.SectionHeader - Appearance.SectionDividerHeight) / 2),
		Size = UDim2.fromOffset(1, Appearance.SectionDividerHeight), BackgroundColor3 = Appearance.Outline, BorderSizePixel = 0,
	}, owned)
	record.NameLabel = title("SectionName", record.Metadata.Name, Appearance.White, nameX, math.max(0, Appearance.CardWidth - 60 - 6 - nameX))
	record.DragHandle = create(app, "ImageButton", "DragHandle", record.Header, Layers.Content, {
		Position = UDim2.new(1, -50, 0, 0), Size = UDim2.fromOffset(24, Appearance.SectionHeader),
		BackgroundTransparency = 1, Image = "", AutoButtonColor = false, Selectable = false,
	}, owned)
	record.DragIcon = create(app, "ImageLabel", "Icon", record.DragHandle, Layers.Content, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 3, 0.5, 0),
		Size = UDim2.fromScale(Appearance.SectionDragIconSize / 24, Appearance.SectionDragIconSize / Appearance.SectionHeader),
		BackgroundTransparency = 1, Image = app._sections.DragAsset or "", ImageColor3 = Appearance.MutedText, ScaleType = Enum.ScaleType.Fit,
	}, owned)
	record.CollapseHandle = create(app, "TextButton", "CollapseHandle", record.Header, Layers.Content, {
		Position = UDim2.new(1, -26, 0, 0), Size = UDim2.fromOffset(24, Appearance.SectionHeader),
		BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Selectable = false,
	}, owned)
	record.Chevron = create(app, "ImageLabel", "Chevron", record.CollapseHandle, Layers.Content, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -2, 0.5, 0),
		Size = UDim2.fromScale(Appearance.SectionCollapseIconSize / 24, Appearance.SectionCollapseIconSize / Appearance.SectionHeader), BackgroundTransparency = 1,
		Image = app._sections.CollapseAsset or "", ImageColor3 = Appearance.MutedText, ScaleType = Enum.ScaleType.Fit,
	}, owned)
	record.Body = create(app, "Frame", "Body", record.Root, Layers.Content, {
		Position = UDim2.fromOffset(Appearance.SectionPadding, Appearance.SectionHeader + 6),
		Size = UDim2.new(1, -Appearance.SectionPadding * 2, 0, 0), BackgroundTransparency = 1,
		Visible = record.Tab.Active and not record.Collapsed, ClipsDescendants = false,
	}, owned)
	record.ContentLayout = create(app, "UIListLayout", "Flow", record.Body, nil, {
		SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
	}, owned)
	Resources.connect(owned, (record.ContentLayout :: UIListLayout):GetPropertyChangedSignal("AbsoluteContentSize"), function() Sections.request(app) end)
	local function collapse()
		if app._life.Phase == "ready" and app._life.Visible and not app._sections.Drag and not app._interaction.Assignment and not app._interaction.ConsumedPointer and Sections.interactive(record) then
			if not rawequal(record.Tab, app._tabs.Settings) and Modes.filtering(app) then
				Motion.prepare(app,"collapse")
				app._search.Collapsed[record.Metadata.Path] = not Modes.collapsed(record)
				record.HeightPending = motionEnabled(app) and record.Root ~= nil and record.Root.Visible
				if Modes.collapsed(record) then releaseBodyFocus(record) end
				Controls.cancel(app, record); Sections.request(app)
			else (record.Handle :: SectionHandle):SetCollapsed(not record.Collapsed) end
		end
	end
	Resources.connect(owned, (record.TitleButton :: TextButton).Activated, collapse)
	Resources.connect(owned, (record.CollapseHandle :: TextButton).Activated, collapse)
	Resources.connect(owned, (record.DragHandle :: ImageButton).InputBegan, function(event) Sections.beginDrag(app, record, event) end)
	Resources.connect(owned, (record.Root :: Frame).Destroying, function()
		if not owned.Closed then (record.Handle :: SectionHandle):Destroy() end
	end)
end
function Tab.AddSection(self: TabInternal, options: SectionOptions): SectionHandle
	local tab, app = self._record, self._record.Owner
	assert(alive(app) and not tab.Scope.Closed, "Cannot add a section to a destroyed tab")
	assert(tab ~= app._tabs.Search, "Search does not own sections; use a user tab or Settings")
	assert(type(options) == "table" and type(options.Id) == "string" and options.Id:match("^[%w_%-]+$"), "Section requires a stable nonempty Id")
	assert(type(options.Name) == "string" and options.Name:match("%S"), "Section requires a metadata Name")
	assert(options.Collapsed == nil or type(options.Collapsed) == "boolean", "Section Collapsed expects boolean")
	Sections.cancelDrag(app)
	local collection = app._sections.ByTab[tab.Metadata.Id]
	if not collection then
		collection = { Order = {}, ById = {} }
		app._sections.ByTab[tab.Metadata.Id] = collection
	end
	assert(collection.ById[options.Id] == nil, "Duplicate section Id in tab: " .. options.Id)
	local record: SectionRecord = {
		Kind = "Section", Metadata = table.freeze({ Id = options.Id, Name = options.Name, TabId = tab.Metadata.Id, Path = tab.Metadata.Id .. "/" .. options.Id }),
		Collapsed = options.Collapsed == true, Destroying = false, RevealPending = false, ExitPending = false, HeightPending = false, Owner = app, Tab = tab, Scope = scope(), NextControlOrder = 0,
		Position = Vector2.zero, Size = Vector2.zero, Column = 1,
	}
	local handle: SectionInternal = table.freeze(setmetatable({ _record = record }, Section)) :: any
	record.Handle = handle
	collection.ById[options.Id] = record
	table.insert(collection.Order, record)
	local area = app._sections
	if area.Reordered then table.insert(area.Order, record) else area.Order = Sections.registrationOrder(app) end
	Resources.own(area.Scope, record.Scope)
	local ok, problem = protected(Sections.build, app, record)
	if not ok then handle:Destroy(); error("Section construction: " .. tostring(problem), 0) end
	if app._life.Phase == "ready" and not area.HeaderIconsStarted then
		Resources.spawn(area.Scope, function() Sections.loadHeaderIcons(app) end)
	end
	Modes.invalidate(app)
	return handle
end
function Tab.GetSection(self: TabInternal, id: string): SectionHandle?
	local collection = self._record.Owner._sections.ByTab[self._record.Metadata.Id]
	local record = if collection then collection.ById[id] else nil
	return if record then record.Handle else nil
end
function Application.GetContentLayout(self: App): ContentStatus
	local area = self._sections
	local result: { { Id: string, TabId: string, Collapsed: boolean, Column: number, Position: Vector2, Size: Vector2 } } = {}
	local preview: { string } = {}
	for _, record in Sections.ordered(self) do
		table.insert(result, { Id = record.Metadata.Id, TabId = record.Metadata.TabId, Collapsed = record.Collapsed,
			Column = record.Column, Position = record.Position, Size = record.Size })
	end
	local drag = area.Drag
	if drag then for _, record in drag.PreviewOrder do table.insert(preview, record.Metadata.TabId .. "/" .. record.Metadata.Id) end end
	return { Columns = area.Columns, CardWidth = area.CardWidth, CanvasHeight = area.CanvasHeight,
		ScrollPosition = if self._view.Content then self._view.Content.CanvasPosition else Vector2.zero, Sections = result,
		DraggingId = if drag then drag.Record.Metadata.TabId .. "/" .. drag.Record.Metadata.Id else nil,
		PendingIndex = if drag and drag.Valid then drag.PendingIndex else nil, PreviewOrder = preview }
end
function Application.GetSettingsContent(self: App): ScrollingFrame? return self._view.SettingsContent end
function Application.GetSearchInput(self: App): TextBox? return self._view.SearchInput end
function Application.GetSearchStatus(self: App): SearchStatus
	if alive(self) then Modes.refresh(self) end
	local record, state = self._tabs.Search, self._search
	return { Active = record ~= nil and record.Active, Editing = state.Editing, Query = state.Query,
		SectionCount = state.SectionCount, ControlCount = state.ControlCount }
end
function Application.GetSettingsLayout(self: App): ContentStatus
	local result: { { Id: string, TabId: string, Collapsed: boolean, Column: number, Position: Vector2, Size: Vector2 } } = {}
	for _, record in Sections.ordered(self, true) do
		table.insert(result, { Id = record.Metadata.Id, TabId = record.Metadata.TabId, Collapsed = record.Collapsed,
			Column = record.Column, Position = record.Position, Size = record.Size })
	end
	local drag, preview = self._sections.Drag, {} :: { string }
	if drag and drag.Record.Tab == self._tabs.Settings then
		for _, record in drag.PreviewOrder do table.insert(preview, record.Metadata.Path) end
	else drag = nil end
	return { Columns = self._settings.Columns, CardWidth = Appearance.CardWidth, CanvasHeight = self._settings.CanvasHeight,
		ScrollPosition = if self._view.SettingsContent then self._view.SettingsContent.CanvasPosition else Vector2.zero,
		Sections = result, PreviewOrder = preview, DraggingId = if drag then drag.Record.Metadata.Path else nil,
		PendingIndex = if drag and drag.Valid then drag.PendingIndex else nil }
end

-- The two utilities share a mode boundary. Nothing here calls control setters,
-- callbacks or actions; only utility activation has its existing callback.
-- Unicode 16.0.0 case folding; queries are still literal substrings.
local SEARCH_CASE_RANGES = table.freeze({
	{ 0xc0, 0xd6, 1, 32 },
	{ 0xd8, 0xde, 1, 32 },
	{ 0x100, 0x12e, 2, 1 },
	{ 0x132, 0x136, 2, 1 },
	{ 0x139, 0x147, 2, 1 },
	{ 0x14a, 0x176, 2, 1 },
	{ 0x179, 0x17d, 2, 1 },
	{ 0x182, 0x184, 2, 1 },
	{ 0x189, 0x18a, 1, 205 },
	{ 0x1a0, 0x1a4, 2, 1 },
	{ 0x1b1, 0x1b2, 1, 217 },
	{ 0x1b3, 0x1b5, 2, 1 },
	{ 0x1cb, 0x1db, 2, 1 },
	{ 0x1de, 0x1ee, 2, 1 },
	{ 0x1f2, 0x1f4, 2, 1 },
	{ 0x1f8, 0x21e, 2, 1 },
	{ 0x222, 0x232, 2, 1 },
	{ 0x246, 0x24e, 2, 1 },
	{ 0x370, 0x372, 2, 1 },
	{ 0x388, 0x38a, 1, 37 },
	{ 0x38e, 0x38f, 1, 63 },
	{ 0x391, 0x3a1, 1, 32 },
	{ 0x3a3, 0x3ab, 1, 32 },
	{ 0x3d8, 0x3ee, 2, 1 },
	{ 0x3fd, 0x3ff, 1, -130 },
	{ 0x400, 0x40f, 1, 80 },
	{ 0x410, 0x42f, 1, 32 },
	{ 0x460, 0x480, 2, 1 },
	{ 0x48a, 0x4be, 2, 1 },
	{ 0x4c1, 0x4cd, 2, 1 },
	{ 0x4d0, 0x52e, 2, 1 },
	{ 0x531, 0x556, 1, 48 },
	{ 0x10a0, 0x10c5, 1, 7264 },
	{ 0x13f8, 0x13fd, 1, -8 },
	{ 0x1c83, 0x1c84, 1, -6210 },
	{ 0x1c90, 0x1cba, 1, -3008 },
	{ 0x1cbd, 0x1cbf, 1, -3008 },
	{ 0x1e00, 0x1e94, 2, 1 },
	{ 0x1ea0, 0x1efe, 2, 1 },
	{ 0x1f08, 0x1f0f, 1, -8 },
	{ 0x1f18, 0x1f1d, 1, -8 },
	{ 0x1f28, 0x1f2f, 1, -8 },
	{ 0x1f38, 0x1f3f, 1, -8 },
	{ 0x1f48, 0x1f4d, 1, -8 },
	{ 0x1f59, 0x1f5f, 2, -8 },
	{ 0x1f68, 0x1f6f, 1, -8 },
	{ 0x1fb8, 0x1fb9, 1, -8 },
	{ 0x1fba, 0x1fbb, 1, -74 },
	{ 0x1fc8, 0x1fcb, 1, -86 },
	{ 0x1fd8, 0x1fd9, 1, -8 },
	{ 0x1fda, 0x1fdb, 1, -100 },
	{ 0x1fe8, 0x1fe9, 1, -8 },
	{ 0x1fea, 0x1feb, 1, -112 },
	{ 0x1ff8, 0x1ff9, 1, -128 },
	{ 0x1ffa, 0x1ffb, 1, -126 },
	{ 0x2160, 0x216f, 1, 16 },
	{ 0x24b6, 0x24cf, 1, 26 },
	{ 0x2c00, 0x2c2f, 1, 48 },
	{ 0x2c67, 0x2c6b, 2, 1 },
	{ 0x2c7e, 0x2c7f, 1, -10815 },
	{ 0x2c80, 0x2ce2, 2, 1 },
	{ 0x2ceb, 0x2ced, 2, 1 },
	{ 0xa640, 0xa66c, 2, 1 },
	{ 0xa680, 0xa69a, 2, 1 },
	{ 0xa722, 0xa72e, 2, 1 },
	{ 0xa732, 0xa76e, 2, 1 },
	{ 0xa779, 0xa77b, 2, 1 },
	{ 0xa77e, 0xa786, 2, 1 },
	{ 0xa790, 0xa792, 2, 1 },
	{ 0xa796, 0xa7a8, 2, 1 },
	{ 0xa7b4, 0xa7c2, 2, 1 },
	{ 0xa7c7, 0xa7c9, 2, 1 },
	{ 0xa7d6, 0xa7da, 2, 1 },
	{ 0xab70, 0xabbf, 1, -38864 },
	{ 0xff21, 0xff3a, 1, 32 },
	{ 0x10400, 0x10427, 1, 40 },
	{ 0x104b0, 0x104d3, 1, 40 },
	{ 0x10570, 0x1057a, 1, 39 },
	{ 0x1057c, 0x1058a, 1, 39 },
	{ 0x1058c, 0x10592, 1, 39 },
	{ 0x10594, 0x10595, 1, 39 },
	{ 0x10c80, 0x10cb2, 1, 64 },
	{ 0x10d50, 0x10d65, 1, 32 },
	{ 0x118a0, 0x118bf, 1, 32 },
	{ 0x16e40, 0x16e5f, 1, 32 },
	{ 0x1e900, 0x1e921, 1, 34 },
})
local SEARCH_CASE_EXCEPTIONS: { [number]: string } = table.freeze({
	[0xb5] = "\206\188",
	[0xdf] = "\115\115",
	[0x130] = "\105\204\135",
	[0x149] = "\202\188\110",
	[0x178] = "\195\191",
	[0x17f] = "\115",
	[0x181] = "\201\147",
	[0x186] = "\201\148",
	[0x187] = "\198\136",
	[0x18b] = "\198\140",
	[0x18e] = "\199\157",
	[0x18f] = "\201\153",
	[0x190] = "\201\155",
	[0x191] = "\198\146",
	[0x193] = "\201\160",
	[0x194] = "\201\163",
	[0x196] = "\201\169",
	[0x197] = "\201\168",
	[0x198] = "\198\153",
	[0x19c] = "\201\175",
	[0x19d] = "\201\178",
	[0x19f] = "\201\181",
	[0x1a6] = "\202\128",
	[0x1a7] = "\198\168",
	[0x1a9] = "\202\131",
	[0x1ac] = "\198\173",
	[0x1ae] = "\202\136",
	[0x1af] = "\198\176",
	[0x1b7] = "\202\146",
	[0x1b8] = "\198\185",
	[0x1bc] = "\198\189",
	[0x1c4] = "\199\134",
	[0x1c5] = "\199\134",
	[0x1c7] = "\199\137",
	[0x1c8] = "\199\137",
	[0x1ca] = "\199\140",
	[0x1f0] = "\106\204\140",
	[0x1f1] = "\199\179",
	[0x1f6] = "\198\149",
	[0x1f7] = "\198\191",
	[0x220] = "\198\158",
	[0x23a] = "\226\177\165",
	[0x23b] = "\200\188",
	[0x23d] = "\198\154",
	[0x23e] = "\226\177\166",
	[0x241] = "\201\130",
	[0x243] = "\198\128",
	[0x244] = "\202\137",
	[0x245] = "\202\140",
	[0x345] = "\206\185",
	[0x376] = "\205\183",
	[0x37f] = "\207\179",
	[0x386] = "\206\172",
	[0x38c] = "\207\140",
	[0x390] = "\206\185\204\136\204\129",
	[0x3b0] = "\207\133\204\136\204\129",
	[0x3c2] = "\207\131",
	[0x3cf] = "\207\151",
	[0x3d0] = "\206\178",
	[0x3d1] = "\206\184",
	[0x3d5] = "\207\134",
	[0x3d6] = "\207\128",
	[0x3f0] = "\206\186",
	[0x3f1] = "\207\129",
	[0x3f4] = "\206\184",
	[0x3f5] = "\206\181",
	[0x3f7] = "\207\184",
	[0x3f9] = "\207\178",
	[0x3fa] = "\207\187",
	[0x4c0] = "\211\143",
	[0x587] = "\213\165\214\130",
	[0x10c7] = "\226\180\167",
	[0x10cd] = "\226\180\173",
	[0x1c80] = "\208\178",
	[0x1c81] = "\208\180",
	[0x1c82] = "\208\190",
	[0x1c85] = "\209\130",
	[0x1c86] = "\209\138",
	[0x1c87] = "\209\163",
	[0x1c88] = "\234\153\139",
	[0x1c89] = "\225\178\138",
	[0x1e96] = "\104\204\177",
	[0x1e97] = "\116\204\136",
	[0x1e98] = "\119\204\138",
	[0x1e99] = "\121\204\138",
	[0x1e9a] = "\097\202\190",
	[0x1e9b] = "\225\185\161",
	[0x1e9e] = "\115\115",
	[0x1f50] = "\207\133\204\147",
	[0x1f52] = "\207\133\204\147\204\128",
	[0x1f54] = "\207\133\204\147\204\129",
	[0x1f56] = "\207\133\204\147\205\130",
	[0x1f80] = "\225\188\128\206\185",
	[0x1f81] = "\225\188\129\206\185",
	[0x1f82] = "\225\188\130\206\185",
	[0x1f83] = "\225\188\131\206\185",
	[0x1f84] = "\225\188\132\206\185",
	[0x1f85] = "\225\188\133\206\185",
	[0x1f86] = "\225\188\134\206\185",
	[0x1f87] = "\225\188\135\206\185",
	[0x1f88] = "\225\188\128\206\185",
	[0x1f89] = "\225\188\129\206\185",
	[0x1f8a] = "\225\188\130\206\185",
	[0x1f8b] = "\225\188\131\206\185",
	[0x1f8c] = "\225\188\132\206\185",
	[0x1f8d] = "\225\188\133\206\185",
	[0x1f8e] = "\225\188\134\206\185",
	[0x1f8f] = "\225\188\135\206\185",
	[0x1f90] = "\225\188\160\206\185",
	[0x1f91] = "\225\188\161\206\185",
	[0x1f92] = "\225\188\162\206\185",
	[0x1f93] = "\225\188\163\206\185",
	[0x1f94] = "\225\188\164\206\185",
	[0x1f95] = "\225\188\165\206\185",
	[0x1f96] = "\225\188\166\206\185",
	[0x1f97] = "\225\188\167\206\185",
	[0x1f98] = "\225\188\160\206\185",
	[0x1f99] = "\225\188\161\206\185",
	[0x1f9a] = "\225\188\162\206\185",
	[0x1f9b] = "\225\188\163\206\185",
	[0x1f9c] = "\225\188\164\206\185",
	[0x1f9d] = "\225\188\165\206\185",
	[0x1f9e] = "\225\188\166\206\185",
	[0x1f9f] = "\225\188\167\206\185",
	[0x1fa0] = "\225\189\160\206\185",
	[0x1fa1] = "\225\189\161\206\185",
	[0x1fa2] = "\225\189\162\206\185",
	[0x1fa3] = "\225\189\163\206\185",
	[0x1fa4] = "\225\189\164\206\185",
	[0x1fa5] = "\225\189\165\206\185",
	[0x1fa6] = "\225\189\166\206\185",
	[0x1fa7] = "\225\189\167\206\185",
	[0x1fa8] = "\225\189\160\206\185",
	[0x1fa9] = "\225\189\161\206\185",
	[0x1faa] = "\225\189\162\206\185",
	[0x1fab] = "\225\189\163\206\185",
	[0x1fac] = "\225\189\164\206\185",
	[0x1fad] = "\225\189\165\206\185",
	[0x1fae] = "\225\189\166\206\185",
	[0x1faf] = "\225\189\167\206\185",
	[0x1fb2] = "\225\189\176\206\185",
	[0x1fb3] = "\206\177\206\185",
	[0x1fb4] = "\206\172\206\185",
	[0x1fb6] = "\206\177\205\130",
	[0x1fb7] = "\206\177\205\130\206\185",
	[0x1fbc] = "\206\177\206\185",
	[0x1fbe] = "\206\185",
	[0x1fc2] = "\225\189\180\206\185",
	[0x1fc3] = "\206\183\206\185",
	[0x1fc4] = "\206\174\206\185",
	[0x1fc6] = "\206\183\205\130",
	[0x1fc7] = "\206\183\205\130\206\185",
	[0x1fcc] = "\206\183\206\185",
	[0x1fd2] = "\206\185\204\136\204\128",
	[0x1fd3] = "\206\185\204\136\204\129",
	[0x1fd6] = "\206\185\205\130",
	[0x1fd7] = "\206\185\204\136\205\130",
	[0x1fe2] = "\207\133\204\136\204\128",
	[0x1fe3] = "\207\133\204\136\204\129",
	[0x1fe4] = "\207\129\204\147",
	[0x1fe6] = "\207\133\205\130",
	[0x1fe7] = "\207\133\204\136\205\130",
	[0x1fec] = "\225\191\165",
	[0x1ff2] = "\225\189\188\206\185",
	[0x1ff3] = "\207\137\206\185",
	[0x1ff4] = "\207\142\206\185",
	[0x1ff6] = "\207\137\205\130",
	[0x1ff7] = "\207\137\205\130\206\185",
	[0x1ffc] = "\207\137\206\185",
	[0x2126] = "\207\137",
	[0x212a] = "\107",
	[0x212b] = "\195\165",
	[0x2132] = "\226\133\142",
	[0x2183] = "\226\134\132",
	[0x2c60] = "\226\177\161",
	[0x2c62] = "\201\171",
	[0x2c63] = "\225\181\189",
	[0x2c64] = "\201\189",
	[0x2c6d] = "\201\145",
	[0x2c6e] = "\201\177",
	[0x2c6f] = "\201\144",
	[0x2c70] = "\201\146",
	[0x2c72] = "\226\177\179",
	[0x2c75] = "\226\177\182",
	[0x2cf2] = "\226\179\179",
	[0xa77d] = "\225\181\185",
	[0xa78b] = "\234\158\140",
	[0xa78d] = "\201\165",
	[0xa7aa] = "\201\166",
	[0xa7ab] = "\201\156",
	[0xa7ac] = "\201\161",
	[0xa7ad] = "\201\172",
	[0xa7ae] = "\201\170",
	[0xa7b0] = "\202\158",
	[0xa7b1] = "\202\135",
	[0xa7b2] = "\202\157",
	[0xa7b3] = "\234\173\147",
	[0xa7c4] = "\234\158\148",
	[0xa7c5] = "\202\130",
	[0xa7c6] = "\225\182\142",
	[0xa7cb] = "\201\164",
	[0xa7cc] = "\234\159\141",
	[0xa7d0] = "\234\159\145",
	[0xa7dc] = "\198\155",
	[0xa7f5] = "\234\159\182",
	[0xfb00] = "\102\102",
	[0xfb01] = "\102\105",
	[0xfb02] = "\102\108",
	[0xfb03] = "\102\102\105",
	[0xfb04] = "\102\102\108",
	[0xfb05] = "\115\116",
	[0xfb06] = "\115\116",
	[0xfb13] = "\213\180\213\182",
	[0xfb14] = "\213\180\213\165",
	[0xfb15] = "\213\180\213\171",
	[0xfb16] = "\213\190\213\182",
	[0xfb17] = "\213\180\213\173",
})
local function searchFold(value: string): string
	if not string.find(value, "[\128-\255]") or not utf8.len(value) then return string.lower(value) end
	local parts: { string } = {}
	for _, code in utf8.codes(value) do
		local exception = SEARCH_CASE_EXCEPTIONS[code]
		if exception then table.insert(parts, exception) else
			local first, last = 1, #SEARCH_CASE_RANGES
			while first <= last do
				local middle = math.floor((first + last) / 2)
				local range = SEARCH_CASE_RANGES[middle]
				if code < range[1] then last = middle - 1
				elseif code > range[2] then first = middle + 1
				else
					if (code - range[1]) % range[3] == 0 then code += range[4] end
					break
				end
			end
			table.insert(parts, utf8.char(code))
		end
	end
	return string.lower(table.concat(parts))
end
local function utilityNotify(record: TabRecord, active: boolean): ()
	if record.Owner._preferences.Restoring then return end
	if record.Scope.Closed or record.Active ~= active then return end
	if record.Callback then
		local ok, problem = protected(record.Callback, active, record.Metadata.Id)
		if not ok then diagnostic("tab " .. record.Metadata.Id .. " callback: " .. tostring(problem)) end
	end
end
function Modes.settingsOpen(app: App): boolean
	local record = app._tabs.Settings
	return record ~= nil and record.Active
end
function Modes.filtering(app: App): boolean
	local record = app._tabs.Search
	return record ~= nil and record.Active and app._search.Query ~= ""
end
function Modes.collapsed(record: SectionRecord): boolean
	if record.Tab ~= record.Owner._tabs.Settings and Modes.filtering(record.Owner) then
		return record.Owner._search.Collapsed[record.Metadata.Path] == true
	end
	return record.Collapsed
end
function Modes.invalidate(app: App): ()
	app._search.Dirty = true
	Sections.request(app)
end
function Modes.matchHost(app: App, path: string, inherited: boolean, query: string): boolean
	local found = inherited
	local function consider(metadata: ControlMetadata, closed: boolean): ()
		if closed then return end
		local mini = app._minis.ByControl[metadata.Path]
		local child = mini ~= nil and not mini.Scope.Closed and Modes.matchHost(app, mini.Metadata.Path, inherited, query)
		if inherited or string.find(searchFold(metadata.Name), query, 1, true) ~= nil or child then
			app._search.Controls[metadata.Path] = true
			app._search.ControlCount += 1
			found = true
		end
	end
	local values = app._values.BySection[path]
	local actions = app._buttons.BySection[path]
	if values then for _, record in values.Order do consider(record.Metadata, record.Scope.Closed) end end
	if actions then for _, record in actions.Order do consider(record.Metadata, record.Scope.Closed) end end
	return found
end
function Modes.rows(app: App, path: string, filtered: boolean): ()
	local function apply(controlPath: string, row: GuiObject?, closed: boolean, slider: SliderRecord?): ()
		if not closed and row then
			local visible = not filtered or app._search.Controls[controlPath] == true
			if not visible then
				if slider then Sliders.cancel(slider) end
				local focused = app._env.Input:GetFocusedTextBox()
				if focused and focused:IsDescendantOf(row) then focused:ReleaseFocus(false) end
			end
			row.Visible = visible
		end
	end
	local values = app._values.BySection[path]
	local actions = app._buttons.BySection[path]
	if values then for _, record in values.Order do apply(record.Metadata.Path, record.Gui.Row, record.Scope.Closed, if record.Kind == "Slider" then record else nil) end end
	if actions then for _, record in actions.Order do apply(record.Metadata.Path, record.Gui.Row, record.Scope.Closed, nil) end end
end
function Modes.refresh(app: App): ()
	local state = app._search
	if not state.Dirty then return end
	state.Dirty = false
	app._metrics.SearchPasses += 1
	table.clear(state.Sections); table.clear(state.Controls)
	state.SectionCount, state.ControlCount = 0, 0
	local filtered, query = Modes.filtering(app), searchFold(state.Query)
	if filtered then
		for _, section in app._sections.Order do
			if not section.Scope.Closed and not rawequal(section.Tab, app._tabs.Search) and not rawequal(section.Tab, app._tabs.Settings) then
				local inherited = string.find(searchFold(section.Tab.Metadata.Name), query, 1, true) ~= nil
					or string.find(searchFold(section.Metadata.Name), query, 1, true) ~= nil
				if Modes.matchHost(app, section.Metadata.Path, inherited, query) then
					state.Sections[section.Metadata.Path] = true; state.SectionCount += 1
				end
			end
		end
	end
	for _, section in app._sections.Order do Modes.rows(app, section.Metadata.Path, filtered and not rawequal(section.Tab, app._tabs.Settings)) end
	for _, node in app._minis.Order do Modes.rows(app, node.Metadata.Path, filtered and not rawequal(node.Tab, app._tabs.Settings)) end
	Modes.paint(app)
end
function Modes.paint(app: App): ()
	local view, settings = app._view, Modes.settingsOpen(app)
	local searchActive = app._tabs.Search ~= nil and (app._tabs.Search :: TabRecord).Active
	local searching = searchActive and not settings
	-- Settings covers the content. Keep its hidden viewport unchanged so the
	-- engine does not clamp the filtered bottom scroll by SearchHeight.
	local inset = if searchActive then Appearance.SearchHeight else 0
	if view.Content then
		local position = UDim2.fromOffset(0, Appearance.PanelHeight + inset)
		local size = UDim2.new(1, 0, 1, -Appearance.PanelHeight - Appearance.FooterHeight - inset)
		if view.Content.Position ~= position then view.Content.Position = position end
		if view.Content.Size ~= size then view.Content.Size = size end
	end
	if view.SettingsLayer then view.SettingsLayer.Visible = settings end
	if view.Content then view.Content.ScrollingEnabled, view.Content.Active = not settings, not settings end
	if view.SettingsContent then view.SettingsContent.ScrollingEnabled, view.SettingsContent.Active = settings, settings end
	if view.SearchLayer then view.SearchLayer.Visible = searching end
	if view.SearchInput then view.SearchInput.Visible = searching and app._life.Visible end
end
function Modes.releaseSearch(app: App): ()
	local box = app._view.SearchInput
	if box and app._env.Input:GetFocusedTextBox() == box then safe(function() box:ReleaseFocus(false) end) end
end
function Modes.cancel(app: App): ()
	Input.finish(app)
	for _, node in app._minis.Order do
		if node.GearImage then node.GearImage.ImageColor3 = Colors.accent(app); node.GearImage.ImageTransparency = 0.15 end
	end
	local focused, screen = app._env.Input:GetFocusedTextBox(), app.ScreenGui
	if focused and screen and focused ~= app._view.SearchInput and focused:IsDescendantOf(screen) then
		safe(function() focused:ReleaseFocus(false) end)
	end
end
function Modes.focus(app: App): ()
	if not app._search.Editing or not app._life.Visible or app._life.Phase ~= "ready" then return end
	if not app._search.SavedScroll and app._view.Content then app._search.SavedScroll = app._view.Content.CanvasPosition end
	Resources.spawn(app._input.Scope, function()
		local box = app._view.SearchInput
		if alive(app) and app._life.Visible and app._search.Editing and not Modes.settingsOpen(app) and box then
			box:CaptureFocus()
		end
	end)
end
function Modes.restore(app: App): ()
	local state, revision = app._search, app._search.Revision
	state.RestoreScroll = state.SavedScroll
	-- UIListLayout settles after row visibility. Keep the desired position until
	-- that frame's final reflow, then let ordinary scrolling own it again.
	Resources.spawn(app._sections.Scope, function()
		task.wait(); task.wait()
		if alive(app) and state.Revision == revision and not Modes.filtering(app) then
			Sections.reflow(app); state.RestoreScroll = nil
		end
	end)
end
function Modes.query(app: App, query: string): ()
	local state, tab = app._search, app._tabs.Search
	if not alive(app) or not tab or not tab.Active or state.Query == query then return end
	state.Query, state.Revision = query, state.Revision + 1
	table.clear(state.Collapsed)
	state.RestoreScroll = nil
	if query == "" then Modes.restore(app)
	elseif app._view.Content then app._view.Content.CanvasPosition = Vector2.zero end
	Modes.invalidate(app)
	Modes.refresh(app)
end
function Modes.search(app: App, active: boolean): ()
	local record = app._tabs.Search
	if not alive(app) or not record or record.Scope.Closed then return end
	if record.Active == active then
		if Modes.settingsOpen(app) then Modes.settings(app, false) end
		return
	end
	Motion.cancel(app); Modes.cancel(app)
	local state = app._search
	state.Revision += 1
	local revision, settings = state.Revision, app._tabs.Settings
	local closedSettings = settings ~= nil and settings.Active
	if closedSettings and settings then settings.Active = false; Tabs.paint(settings) end
	state.Editing = active
	if active then
		state.SavedScroll = if app._view.Content then app._view.Content.CanvasPosition else Vector2.zero
		state.RestoreScroll = nil
	else
		Modes.releaseSearch(app)
		state.Query = ""
		table.clear(state.Collapsed)
		if app._view.SearchInput then app._view.SearchInput.Text = "" end
		Modes.restore(app)
	end
	state.Dirty = true
	record.Active = active; Tabs.paint(record)
	Modes.refresh(app); Sections.request(app)
	if closedSettings and settings then utilityNotify(settings, false) end
	if alive(app) and state.Revision == revision then utilityNotify(record, active) end
	if alive(app) then Modes.focus(app) end
end
function Modes.finishSearch(app: App): ()
	if not app._search.Editing then return end
	local box = app._view.SearchInput
	if box then Modes.query(app, box.Text) end
	app._search.Editing = false
	Modes.releaseSearch(app)
	Modes.paint(app); Sections.request(app)
end
function Modes.settings(app: App, active: boolean): ()
	local record = app._tabs.Settings
	if not alive(app) or not record or record.Scope.Closed or record.Active == active then return end
	Motion.cancel(app); Modes.cancel(app)
	local box = app._view.SearchInput
	if app._search.Editing and box then Modes.query(app, box.Text) end
	local state, search = app._search, app._tabs.Search
	state.Revision += 1
	local revision = state.Revision
	state.Editing = false
	Modes.releaseSearch(app)
	local closedSearch = search ~= nil and search.Active and state.Query == ""
	if closedSearch and search then
		search.Active = false; Tabs.paint(search)
		Modes.restore(app); state.Dirty = true
	end
	record.Active = active; Tabs.paint(record)
	Modes.refresh(app); Modes.paint(app); Sections.request(app)
	if closedSearch and search then utilityNotify(search, false) end
	if alive(app) and state.Revision == revision then utilityNotify(record, active) end
end
function Modes.build(app: App): ()
	local view = app._view
	view.SettingsLayer = create(app, "TextButton", "SettingsLayer", view.Root, Layers.Settings, {
		Position = UDim2.fromOffset(0, Appearance.PanelHeight), Size = UDim2.new(1, 0, 1, -Appearance.PanelHeight - Appearance.FooterHeight),
		Text = "", BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = Appearance.SettingsDimTransparency,
		Active = true, AutoButtonColor = false, Selectable = false, ClipsDescendants = true, Visible = false,
	})
	edgeCorners(app, view.SettingsLayer :: TextButton, 0, 0)
	view.SettingsContent = create(app, "ScrollingFrame", "SettingsContent", view.SettingsLayer, Layers.SettingsContent, {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Active = false, ClipsDescendants = true,
		CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.None,
		ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 0, VerticalScrollBarInset = Enum.ScrollBarInset.None,
		ElasticBehavior = Enum.ElasticBehavior.Never, ScrollingEnabled = false,
	})
	Resources.connect(app._sections.Scope, (view.SettingsContent :: ScrollingFrame):GetPropertyChangedSignal("AbsoluteWindowSize"), function() Sections.request(app) end)
	Resources.connect(app._sections.Scope, (view.SettingsContent :: ScrollingFrame):GetPropertyChangedSignal("CanvasPosition"), function()
		local drag = app._sections.Drag
		if drag and drag.Record.Tab == app._tabs.Settings then Sections.moveDrag(app, drag.Point) end
	end)
	view.SearchLayer = create(app, "Frame", "SearchLayer", view.Root, Layers.Search, {
		Position = UDim2.fromOffset(0, Appearance.PanelHeight), Size = UDim2.new(1, 0, 0, Appearance.SearchHeight),
		BackgroundTransparency = 1, ClipsDescendants = true, Active = false,
	})
	view.SearchInput = create(app, "TextBox", "SearchInput", view.SearchLayer, Layers.Search, {
		Position = UDim2.fromOffset(12, 6), Size = UDim2.new(1, -24, 0, 28),
		BackgroundColor3 = Appearance.Field, BackgroundTransparency = 0.18, TextColor3 = Appearance.Value, PlaceholderColor3 = Appearance.MutedText,
		Text = "", PlaceholderText = "Search...", TextSize = 13, FontFace = REGULAR_FACE,
		ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, MultiLine = false, ClipsDescendants = true, Visible = false,
	})
	corner(app, view.SearchInput :: TextBox, 6)
	stroke(app, view.SearchInput :: TextBox, Appearance.FieldOutline)
	create(app, "UIPadding", "Padding", view.SearchInput, nil, { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
	Resources.connect(app._input.Scope, (view.SearchInput :: TextBox):GetPropertyChangedSignal("Text"), function()
		if view.SearchInput then Modes.query(app, view.SearchInput.Text) end
	end)
	Resources.connect(app._input.Scope, (view.SearchInput :: TextBox).Focused, function()
		if Gui.showing(app) and not Modes.settingsOpen(app) and (app._tabs.Search :: TabRecord).Active then
			Modes.cancel(app); app._search.Editing = true
		end
	end)
	Resources.connect(app._input.Scope, (view.SearchInput :: TextBox).FocusLost, function()
		if alive(app) then Modes.finishSearch(app) end
	end)
	Modes.paint(app)
end

-- Control values have their own owner. Geometry/visibility never write them.
function Controls.paint(record: ToggleRecord, instant: boolean?): ()
	if record.Scope.Closed then return end
	if record.Gui.Track then Motion.to(record.Owner,record.Scope,record.Gui.Track,{ BackgroundColor3 = if record.Model.Value then Colors.accent(record.Owner) else Appearance.ToggleOff },0.11,nil,instant) end
	if record.Gui.Thumb then
		Motion.to(record.Owner,record.Scope,record.Gui.Thumb,{
			BackgroundColor3 = if record.Model.Value then Colors.contrast(Colors.accent(record.Owner)) else Appearance.ToggleThumb,
			Position = UDim2.fromOffset(if record.Model.Value then Appearance.ToggleWidth - 12 - Appearance.ToggleInset else Appearance.ToggleInset, Appearance.ToggleInset),
		},0.11,nil,instant)
	end
end
function Toggle.Get(self: ToggleInternal): boolean return self._record.Model.Value end
function Toggle.GetMetadata(self: ToggleInternal): ControlMetadata return self._record.Metadata end
function Toggle.GetButton(self: ToggleInternal): TextButton? return self._record.Gui.Row end
function Toggle.IsDestroyed(self: ToggleInternal): boolean return self._record.Scope.Closed end
function Toggle.Set(self: ToggleInternal, value: boolean, options: ToggleSetOptions?): ()
	assert(type(value) == "boolean", "Toggle Set requires boolean")
	Controls.options(options)
	local record = self._record
	if record.Scope.Closed or (record.Model.Value == value and not (options and options.Replay)) then return end
	record.Model.Value = value
	Controls.paint(record)
	if record.Owner._preferences.Animations == record then Motion.policy(record.Owner) end
	Controls.emit(record, value, options)
end
function Toggle.Destroy(self: ToggleInternal): ()
	if not self._record.Scope.Closed then Controls.remove(self._record) end
end
function Controls.destroySection(section: ControlHost): ()
	Controls.cancel(section.Owner, section)
	local collection = section.Owner._values.BySection[section.Metadata.Path]
	if collection then
		for _, record in table.clone(collection.Order) do if record.Handle then record.Handle:Destroy() end end
	end
	local actions = section.Owner._buttons.BySection[section.Metadata.Path]
	if actions then
		for _, record in table.clone(actions.Order) do if record.Handle then record.Handle:Destroy() end end
	end
end
function Controls.build(record: ToggleRecord, order: number): ()
	local app, owned = record.Owner, record.Scope
	record.Gui.Row = create(app, "TextButton", "Toggle_" .. record.Metadata.Id, record.Section.Body, Layers.Content, {
		Size = UDim2.new(1, 0, 0, Appearance.ToggleRow), LayoutOrder = order,
		BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Selectable = false,
	}, owned)
	record.Gui.Label = create(app, "TextLabel", "Label", record.Gui.Row, Layers.Content, {
		Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1, Text = record.Metadata.Name,
		TextColor3 = Appearance.White, TextSize = 12,
		FontFace = Font.new("rbxasset://fonts/families/JosefinSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, owned)
	record.Gui.Track = create(app, "Frame", "Track", record.Gui.Row, Layers.Content, {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(Appearance.ToggleWidth, Appearance.ToggleHeight),
		BackgroundColor3 = Appearance.ToggleOff,
	}, owned)
	corner(app, record.Gui.Track :: Frame, 8, owned)
	record.Gui.Thumb = create(app, "Frame", "Thumb", record.Gui.Track, Layers.Content, {
		Size = UDim2.fromOffset(12, 12), Position = UDim2.fromOffset(2, 2),
		BackgroundColor3 = Appearance.ToggleThumb,
	}, owned)
	corner(app, record.Gui.Thumb :: Frame, 6, owned)
	Controls.paint(record)
	Resources.connect(owned, (record.Gui.Row :: TextButton).Activated, function(event)
		if Controls.interactive(record) and not Mini.gearHit(record, event) then
			(record.Handle :: ToggleHandle):Set(not record.Model.Value)
		end
	end)
	Resources.connect(owned, (record.Gui.Row :: TextButton).Destroying, function()
		if not owned.Closed then (record.Handle :: ToggleHandle):Destroy() end
	end)
end
function Section.AddToggle(self: SectionInternal | MiniInternal, options: ToggleOptions): ToggleHandle
	local section, app = self._record, self._record.Owner
	local metadata = Controls.metadata(section, options)
	assert(type(options.Default) == "boolean", "Toggle requires boolean Default")
	assert(options.Callback == nil or type(options.Callback) == "function", "Toggle Callback requires function")
	local record: ToggleRecord = {
		Kind = "Toggle", Gui={}, Metadata = metadata, Model = { Kind = "Toggle", Metadata = metadata, Default = options.Default, Value = options.Default }, Callback = options.Callback, Scope = scope(), Owner = app, Section = section,
	}
	return Controls.mount(record, Toggle, function(order) Controls.build(record, order) end)
end
function Section.GetToggle(self: SectionInternal | MiniInternal, id: string): ToggleHandle?
	local collection = self._record.Owner._values.BySection[self._record.Metadata.Path]
	local record = if collection then collection.ById[id] else nil
	return if record and record.Kind == "Toggle" then record.Handle else nil
end


-- Dropdown and keybind values share only registration/lifecycle with Toggle.
-- Transient popup/assignment state is separate from persistent control values.
function Controls.emit(record: ControlRecord, value: any, options: ValueSetOptions?): ()
	if record.Scope.Closed or record.Owner._preferences.Restoring or (options and options.Emit == false) or not record.Callback then return end
	local payload = if record.Kind == "MultiDropdown" then table.clone(value) else value
	local ok, problem = protected(record.Callback, payload, record.Metadata.Id)
	if not ok then diagnostic(record.Kind .. " " .. record.Metadata.Path .. " callback: " .. tostring(problem)) end
end
function Controls.options(options: ValueSetOptions?): ()
	assert(options == nil or (type(options) == "table" and (options.Emit == nil or type(options.Emit) == "boolean")), "Set options require boolean Emit")
	assert(options == nil or options.Replay == nil or type(options.Replay) == "boolean", "Set options require boolean Replay")
end
function Controls.available(record: ControlView): boolean
	local app, section = record.Owner, record.Section
	return not record.Scope.Closed and Gui.showing(app)
		and Mini.hostVisible(section) and not section.Scope.Closed
		and record.Gui.Row ~= nil and record.Gui.Row.Visible and record.Gui.Row.Parent == section.Body
		and not app._sections.Drag and not app._input.Gesture
		and (not app._interaction.Surface or app._interaction.Surface.Color == record or app._interaction.Surface.Slider == record)
end
function Controls.interactive(record: ControlView): boolean
	local interaction = record.Owner._interaction
	return Controls.available(record) and not interaction.Assignment and not interaction.ConsumedPointer
end
function Controls.contains(object: GuiObject?, at: Vector2): boolean
	if not object then return false end
	local p, s = object.AbsolutePosition, object.AbsoluteSize
	return at.X >= p.X and at.Y >= p.Y and at.X <= p.X+s.X and at.Y <= p.Y+s.Y
end
function Controls.closePopup(app: App, instant: boolean?): ()
	local popup = app._interaction.Popup
	if not popup then return end
	app._interaction.Popup = nil
	popup.Closing = true
	if popup.Measurement then Resources.close(popup.Measurement) end
	popup.Root.Active, popup.Root.ScrollingEnabled = false, false
	for _, option in popup.Options do option.Button.Active = false end
	if popup.Record.Gui.Chevron then Motion.to(app,popup.Record.Scope,popup.Record.Gui.Chevron,{Rotation=180},0.10,nil,instant) end
	if instant or not motionEnabled(app) then Resources.close(popup.Scope); return end
	app._motion.Closing[popup.Record.Metadata.Path] = { Scope = popup.Scope, Path = popup.Record.Section.Metadata.Path }
	Motion.popup(app,popup,true)
end
function Controls.cancelAssignment(app: App): ()
	local record = app._interaction.Assignment
	app._interaction.Assignment = nil
	if record then Controls.paintKeybind(record) end
end
function Controls.cancel(app: App, section: ControlHost?): ()
	local interaction = app._interaction
	if not section or section == app._configs.Section then Configs.close(app) end
	if interaction.Editor and (not section or Mini.belongs(interaction.Editor.Section,section)) then Sliders.finish(interaction.Editor,false) end
	if interaction.Surface and interaction.Surface.Slider and (not section or Mini.belongs(interaction.Surface.Slider.Section,section)) then interaction.Surface=nil end
	if interaction.Color and (not section or Mini.belongs(interaction.Color.Record.Section, section)) then Colors.close(app) end
	if section then Mini.closeHost(app, section) end
	if interaction.Popup and (not section or Mini.belongs(interaction.Popup.Record.Section, section)) then Controls.closePopup(app,true) end
	for _, popup in table.clone(app._motion.Closing) do
		if not section or popup.Path == section.Metadata.Path or popup.Path:sub(1,#section.Metadata.Path+1) == section.Metadata.Path.."/" then Resources.close(popup.Scope) end
	end
	if interaction.Assignment and (not section or Mini.belongs(interaction.Assignment.Section, section)) then Controls.cancelAssignment(app) end
	for _, collection in app._buttons.BySection do
		for _, record in collection.Order do
			if not section or Mini.belongs(record.Section, section) then record.Hovered, record.Pressed = false, false; Controls.paintButton(record) end
		end
	end
end
function Controls.remove(record: ControlView): ()
	local app = record.Owner
	if app._background.Accent == record then app._background.Accent = nil end
	if app._background.Selection == record then app._background.Selection = nil end
	if app._background.Dimming == record then app._background.Dimming = nil end
	if app._preferences.Accent == record then app._preferences.Accent = nil end
	if app._preferences.MenuBinding == record then
		app._preferences.InitialKey, app._preferences.MenuBinding = (record :: KeybindRecord).Model.Value, nil
	end
	if app._preferences.Animations == record then
		app._preferences.InitialAnimations, app._preferences.Animations = (record :: ToggleRecord).Model.Value, nil
	end
	if record.Kind=="Slider" then Sliders.cancel(record) end
	if app._interaction.Color and app._interaction.Color.Record == record then Colors.close(app) end
	local mini = app._minis.ByControl[record.Metadata.Path]; if mini then Mini.destroy(mini) end
	if app._interaction.Popup and app._interaction.Popup.Record == record then Controls.closePopup(app,true) end
	if app._interaction.Assignment == record then Controls.cancelAssignment(app) end
	Resources.close(record.Scope)
	if record.Kind == "Button" then
		if app._buttons.ByPath[record.Metadata.Path] == record then app._buttons.ByPath[record.Metadata.Path] = nil end
		local actions = app._buttons.BySection[record.Section.Metadata.Path]
		if actions then
			actions.ById[record.Metadata.Id] = nil
			local at = table.find(actions.Order, record)
			if at then table.remove(actions.Order, at) end
			if #actions.Order == 0 then app._buttons.BySection[record.Section.Metadata.Path] = nil end
		end
	else
		local flag = record.Metadata.Flag or record.Metadata.Path
		if app._values.ByFlag[flag] == record then app._values.ByFlag[flag] = nil end
		if app._values.ByPath[record.Metadata.Path] == record.Model then app._values.ByPath[record.Metadata.Path] = nil end
		local values = app._values.BySection[record.Section.Metadata.Path]
		if values then
			values.ById[record.Metadata.Id] = nil
			local at = table.find(values.Order, record)
			if at then table.remove(values.Order, at) end
			if #values.Order == 0 then app._values.BySection[record.Section.Metadata.Path] = nil end
		end
	end
	Controls.layout(record.Section)
end
function Controls.register(section: ControlHost, record: ControlView): number
	local app = section.Owner
	assert(alive(app) and not section.Scope.Closed and not section.Destroying, "Cannot add control to destroyed section")
	assert(record.Metadata.Id:match("^[%w_%-]+$"), "Control requires stable nonempty Id")
	assert(record.Metadata.Name:match("%S"), "Control requires Name")
	local values = app._values.BySection[section.Metadata.Path]
	local actions = app._buttons.BySection[section.Metadata.Path]
	assert((not values or not values.ById[record.Metadata.Id]) and (not actions or not actions.ById[record.Metadata.Id]),
		"Duplicate control Id in section: " .. record.Metadata.Id)
	assert(not app._values.ByPath[record.Metadata.Path] and not app._buttons.ByPath[record.Metadata.Path], "Duplicate control Path: " .. record.Metadata.Path)
	local flag = record.Metadata.Flag or record.Metadata.Path
	if record.Kind ~= "Button" then assert(not app._values.ByFlag[flag], "Duplicate Flag: " .. flag) end
	Sections.cancelDrag(app)
	Controls.cancel(app)
	if record.Kind == "Button" then
		app._buttons.ByPath[record.Metadata.Path] = record
		if not actions then actions = { Order = {}, ById = {} }; app._buttons.BySection[section.Metadata.Path] = actions end
		local registered = actions :: { Order: { ButtonRecord }, ById: { [string]: ButtonRecord } }
		table.insert(registered.Order, record); registered.ById[record.Metadata.Id] = record
		Resources.own(app._buttons.Scope, record.Scope)
	else
		app._values.ByFlag[flag] = record
		app._values.ByPath[record.Metadata.Path] = record.Model
		if not values then values = { Order = {}, ById = {} }; app._values.BySection[section.Metadata.Path] = values end
		local registered = values :: ControlCollection
		table.insert(registered.Order, record); registered.ById[record.Metadata.Id] = record
		Resources.own(app._values.Scope, record.Scope)
	end
	Resources.add(record.Scope, function() Controls.clear(record) end)
	section.NextControlOrder += 1
	return section.NextControlOrder
end
function Controls.clear(record: ControlView): ()
	if record.Kind == "Slider" then Sliders.cancel(record) end
	-- Gui fields are optional; clearing the view never touches its value model.
	local view: any = record
	table.clear(view.Gui)
	view.Callback = nil
	if record.Kind == "Keybind" then record.CapturedInput = nil end
	if record.Kind == "Dropdown" or record.Kind == "MultiDropdown" then
		table.clear(record.Text.Cache)
		record.Text.Summary, record.Text.Candidate, record.Text.SummaryWidth = nil, nil, nil
	elseif record.Kind == "Button" then
		record.Revision += 1
		record.Hovered, record.Pressed, record.Busy, record.Flashing = false, false, false, false
		record.Status, record.Run, record.Feedback = nil, nil, nil
	end
end
function Controls.mount(record: ControlView, prototype: any, build: (number) -> ()): any
	local order = Controls.register(record.Section, record)
	local handle = table.freeze(setmetatable({ _record = record }, prototype))
	local view: any = record
	view.Handle = handle
	local ok, problem = protected(build, order)
	if not ok then
		Controls.remove(record)
		error(record.Kind .. " construction: " .. tostring(problem), 0)
	end
	Controls.layout(record.Section)
	return handle
end
function Controls.metadata(section: ControlHost, options: { Id: string, Name: string, Flag: string? }): ControlMetadata
	assert(type(options) == "table" and type(options.Id) == "string" and type(options.Name) == "string", "Control requires Id and Name")
	assert(options.Flag == nil or (type(options.Flag) == "string" and options.Flag ~= ""), "Flag must be a nonempty string")
	return table.freeze({ Id = options.Id, Name = options.Name, Flag = options.Flag, TabId = section.Metadata.TabId,
		SectionId = if section.Kind == "MiniSection" then section.RootSection.Metadata.Id else section.Metadata.Id,
		Path = section.Metadata.Path .. "/" .. options.Id, ParentControlId = section.Metadata.ParentControlId, ParentControlPath = section.Metadata.ParentControlPath })
end
local CONTROL_FACE = Font.new("rbxasset://fonts/families/JosefinSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
function Controls.text(record: SelectRecord | KeybindRecord | ColorRecord | ButtonRecord, parent: Instance, name: string, text: string, size: number): TextLabel
	return create(record.Owner, "TextLabel", name, parent, Layers.Content, {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = text, TextSize = size,
		FontFace = CONTROL_FACE, TextColor3 = Appearance.Value, TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, record.Scope)
end
function Controls.field(record: SelectRecord | KeybindRecord | ColorRecord | ButtonRecord, order: number, width: number, height: number): ()
	local app, owned = record.Owner, record.Scope
	record.Gui.Row = create(app, "Frame", record.Kind .. "_" .. record.Metadata.Id, record.Section.Body, Layers.Content, {
		Size = UDim2.new(1, 0, 0, Appearance.ControlHeight), LayoutOrder = order, BackgroundTransparency = 1,
	}, owned)
	local label = Controls.text(record, record.Gui.Row :: Frame, "Label", record.Metadata.Name, 12)
	record.Gui.Label = label
	label.Size = UDim2.new(1, -width - 10, 1, 0)
	label.TextColor3 = Appearance.White
	record.Gui.Field = create(app, "TextButton", "Field", record.Gui.Row, Layers.Content, {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = Appearance.Field, BackgroundTransparency = 0.2, Text = "", AutoButtonColor = false, Selectable = false,
	}, owned)
	corner(app, record.Gui.Field :: TextButton, 6, owned)
	create(app, "UIStroke", "Outline", record.Gui.Field, nil, {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1, Color = Appearance.FieldOutline, Transparency = 0.45,
	}, owned)
	record.Gui.ValueLabel = Controls.text(record, record.Gui.Field :: TextButton, "Value", "", 11)
	Resources.connect(owned, (record.Gui.Row :: Frame).Destroying, function() if not owned.Closed then Controls.remove(record) end end)
	Resources.connect(owned, (record.Gui.Field :: TextButton).Destroying, function() if not owned.Closed then Controls.remove(record) end end)
	Resources.connect(owned, (record.Gui.Row :: Frame).AncestryChanged, function()
		if record.Gui.Row and record.Gui.Row.Parent ~= record.Section.Body then Controls.cancel(app, record.Section) end
	end)
	Resources.connect(owned, (record.Gui.Row :: Frame):GetPropertyChangedSignal("Visible"), function()
		if not Controls.interactive(record) then Controls.cancel(app, record.Section) end
	end)
end
function Controls.validateValues(values: { string }): { string }
	assert(type(values) == "table" and #values > 0, "Dropdown Values require a nonempty dense string array")
	local count, copy = 0, {}
	for key, value in next, values do
		assert(type(key) == "number" and key % 1 == 0 and key >= 1 and key <= #values, "Dropdown Values require a dense array")
		assert(type(value) == "string" and value ~= "", "Dropdown Values require nonempty strings")
		count += 1
	end
	assert(count == #values, "Dropdown Values require a dense array")
	local seen: { [string]: boolean } = {}
	for index = 1, #values do
		local value = values[index]
		assert(not seen[value], "Dropdown Values must be unique")
		seen[value] = true; copy[index] = value
	end
	return table.freeze(copy)
end
function Controls.paintPopup(popup: DropdownPopup): ()
	if popup.Scope.Closed then return end
	local selected: { [string]: boolean } = {}
	if popup.Record.Kind == "MultiDropdown" then
		for _, value in popup.Record.Model.Value do selected[value] = true end
	else selected[popup.Record.Model.Value] = true end
	local metrics = popup.Record.Owner._metrics
	for _, option in popup.Options do
		option.Label.TextColor3 = if selected[option.Value] then Colors.accent(popup.Record.Owner) else Appearance.Value
		if option.Button.BackgroundColor3 ~= Appearance.Selected then option.Button.BackgroundColor3 = Appearance.Selected; metrics.PopupPaintWrites += 1 end
		local transparency = if selected[option.Value] then 0 elseif option.Button == popup.Hovered then 0.5 else 1
		local targets = popup.Record.Owner._motion.Alphas[option.Button]
		local authored = if targets and targets.BackgroundTransparency then targets.BackgroundTransparency.Base else option.Button.BackgroundTransparency
		if authored ~= transparency then Motion.alpha(popup.Record.Owner,option.Button,"BackgroundTransparency",transparency); metrics.PopupPaintWrites += 1 end
	end
end
-- These caches belong to one control and never retain an unbounded dynamic list.
function Controls.measureBounds(record: SelectRecord, owner: Scope, text: string, width: number, font: Font, size: number): Vector2?
	if owner.Closed or record.Scope.Closed then return nil end
	local state = record.Text
	if state.Font ~= font or state.Size ~= size then
		table.clear(state.Cache); state.Count, state.Font, state.Size = 0, font, size
	end
	local key = tostring(width) .. ":" .. text
	if state.Cache[key] then return state.Cache[key] end
	local params = Instance.new("GetTextBoundsParams")
	local detach = Resources.add(owner, function() params:Destroy() end)
	params.Text, params.Font, params.Size, params.Width, params.RichText = text, font, size, width, false
	record.Owner._metrics.TextMeasurements += 1
	local ok, bounds = protected(function() return (game:GetService("TextService") :: TextService):GetTextBoundsAsync(params) end)
	detach(); params:Destroy()
	if owner.Closed or record.Scope.Closed or state.Font ~= font or state.Size ~= size then return nil end
	if not ok or typeof(bounds) ~= "Vector2" or not finite(bounds.X) or not finite(bounds.Y) or bounds.X < 0 or bounds.Y < 0 then return nil end
	if state.Count >= 128 then table.clear(state.Cache); state.Count = 0 end
	state.Cache[key], state.Count = bounds, state.Count + 1
	return bounds
end
function Controls.measureSummary(record: SelectRecord): ()
	local label, state = record.Gui.ValueLabel, record.Text
	if record.Scope.Closed or not label then return end
	if record.Kind == "Dropdown" or #record.Model.Value <= 1 then
		if state.Summary then Resources.close(state.Summary); state.Summary = nil end
		state.Candidate, state.Available, state.SummaryWidth = nil, nil, nil
		label.Text = if record.Kind == "Dropdown" then record.Model.Value elseif #record.Model.Value == 0 then "None" else record.Model.Value[1]
		return
	end
	local candidate, count = table.concat(record.Model.Value, ", "), #record.Model.Value
	local available, font, size = label.AbsoluteSize.X, label.FontFace, label.TextSize
	if state.Candidate == candidate and state.Available == available and state.Font == font and state.Size == size then
		label.Text = if state.SummaryWidth and state.SummaryWidth <= available then candidate else tostring(count) .. " selected"
		return
	end
	if state.Summary then Resources.close(state.Summary) end
	local owned = scope()
	state.Summary, state.Candidate, state.Available, state.SummaryWidth = owned, candidate, available, nil
	Resources.own(record.Scope, owned)
	Resources.add(owned, function() if state.Summary == owned then state.Summary = nil end end)
	label.Text = tostring(count) .. " selected"
	Resources.spawn(owned, function()
		local bounds = Controls.measureBounds(record, owned, candidate, math.huge, font, size)
		if owned.Closed or record.Scope.Closed or state.Summary ~= owned or record.Gui.ValueLabel ~= label then return end
		if label.AbsoluteSize.X ~= available or label.FontFace ~= font or label.TextSize ~= size then return end
		if bounds then
			state.SummaryWidth = bounds.X
			label.Text = if bounds.X <= available then candidate else tostring(count) .. " selected"
		end
		Resources.close(owned)
	end)
end
function Controls.fieldAccent(record: SelectRecord | KeybindRecord): ()
	local color = Colors.accent(record.Owner)
	if record.Kind == "Keybind" then
		if record.Gui.ValueLabel then record.Gui.ValueLabel.TextColor3 = if record.Model.Value == nil and record.Owner._interaction.Assignment ~= record then color else Appearance.White end
		if record.Gui.Field then record.Gui.Field.BackgroundColor3 = Appearance.Field end
	elseif record.Gui.ValueLabel then record.Gui.ValueLabel.TextColor3 = color end
end
function Controls.paintDropdown(record: SelectRecord): ()
	if record.Scope.Closed then return end
	Controls.fieldAccent(record)
	Controls.measureSummary(record)
	local popup = record.Owner._interaction.Popup
	if popup and popup.Record == record then Controls.paintPopup(popup) end
end
function Controls.measurePopup(popup: DropdownPopup, width: number): ()
	if popup.Measurement then Resources.close(popup.Measurement) end
	local owned, record = scope(), popup.Record
	popup.Measurement, popup.MeasureWidth = owned, width
	Resources.own(popup.Scope, owned)
	Resources.add(owned, function() if popup.Measurement == owned then popup.Measurement = nil end end)
	local function current(): boolean
		return not owned.Closed and not popup.Scope.Closed and not record.Scope.Closed and not popup.Closing
			and record.Owner._interaction.Popup == popup and record.Model.Values == popup.Choices
	end
	Resources.spawn(owned, function()
		if not current() then return end
		if popup.TextWidth == nil then
			local longest, failed = 0, false
			for index, option in popup.Options do
				if not current() then return end
				local bounds = Controls.measureBounds(record, owned, option.Value, math.huge, option.Label.FontFace, option.Label.TextSize)
				if not current() then return end
				if bounds then longest = math.max(longest, bounds.X) else failed = true end
				if index % 32 == 0 then task.wait() end
			end
			if not current() then return end
			-- Failed measurement still leaves wrapped, engine-sized labels readable.
			popup.TextWidth = if failed then math.huge else math.ceil(longest) + 28
			Controls.placePopup(popup)
			if not current() then return end
		end
		for index, option in popup.Options do
			if not current() then return end
			local bounds = Controls.measureBounds(record, owned, option.Value, math.max(1, width - 28), option.Label.FontFace, option.Label.TextSize)
			if not current() then return end
			option.Height = math.max(Appearance.OptionHeight, math.ceil(if bounds then bounds.Y else option.Label.AbsoluteSize.Y) + 12)
			if index % 32 == 0 then task.wait() end
		end
		if current() then Controls.placePopup(popup) end
		Resources.close(owned)
	end)
end
function Controls.placePopup(popup: DropdownPopup): ()
	local record, app = popup.Record, popup.Record.Owner
	local overlay, scroll, field = app._view.Overlay, app._view.Content, record.Gui.Field
	if popup.Scope.Closed or popup.Closing then return end
	if not Controls.interactive(record) or not overlay or not scroll or not field then Controls.closePopup(app); return end
	local anchor, fs = field.AbsolutePosition, field.AbsoluteSize
	if not Floating.anchorVisible(record, field) then Controls.closePopup(app); return end
	local at, viewport = anchor-overlay.AbsolutePosition, overlay.AbsoluteSize
	local inset = math.min(Appearance.PopupInset, math.max(0, math.min(viewport.X, viewport.Y)/2))
	local wanted, content = Appearance.PopupInset*2, Appearance.PopupInset
	for index, option in popup.Options do
		option.Button.Position = UDim2.fromOffset(Appearance.PopupInset, content)
		option.Button.Size = UDim2.new(1, -Appearance.PopupInset*2, 0, option.Height)
		content += option.Height
		if index <= 6 then wanted += option.Height end
	end
	content += Appearance.PopupInset
	local below = math.max(0, viewport.Y-inset-at.Y-fs.Y-4)
	local above = math.max(0, at.Y-inset-4)
	local upward = below < wanted and above > below
	local height = math.min(wanted, if upward then above else below)
	local width = math.min(math.max(fs.X, Appearance.DropdownWidth, popup.TextWidth or 0), math.max(0, viewport.X-inset*2))
	if height <= 0 or width <= 0 then Controls.closePopup(app); return end
	popup.Root.Size = UDim2.fromOffset(width, height)
	popup.Root.Position = UDim2.fromOffset(
		math.clamp(at.X+fs.X-width, inset, math.max(inset, viewport.X-width-inset)),
		if upward then at.Y-height-4 else at.Y+fs.Y+4)
	popup.Root.CanvasSize = UDim2.fromOffset(0, content)
	popup.Root.CanvasPosition = Vector2.new(0, math.clamp(popup.Root.CanvasPosition.Y, 0, math.max(0, content-height)))
	if popup.MeasureWidth ~= width then Controls.measurePopup(popup, width) end
end
function Controls.openDropdown(record: SelectRecord): ()
	local app = record.Owner
	if not Controls.interactive(record) or not app._icons.DropdownAsset then return end
	if app._interaction.Popup and app._interaction.Popup.Record == record then Controls.closePopup(app); return end
	Controls.cancel(app)
	local owned = scope()
	local created, root = protected(function()
		return create(app, "ScrollingFrame", "DropdownPopup", app._view.Overlay, Layers.Popup, {
		BackgroundColor3 = Appearance.Card, BackgroundTransparency = 0.08, ClipsDescendants = true,
		ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y, AutomaticCanvasSize = Enum.AutomaticSize.None,
		ElasticBehavior = Enum.ElasticBehavior.Never, Active = true,
	}, owned) :: ScrollingFrame
	end)
	if not created then Resources.close(owned); diagnostic("dropdown allocation: " .. tostring(root)); return end
	local popup: DropdownPopup = { Scope = owned, Record = record, Root = root, Options = {}, Closing = false, Choices = record.Model.Values }
	app._interaction.Popup = popup
	Resources.own(record.Scope,owned)
	Resources.add(owned,function()
		if app._interaction.Popup == popup then app._interaction.Popup = nil end
		local entry = app._motion.Closing[record.Metadata.Path]
		if entry and entry.Scope == owned then app._motion.Closing[record.Metadata.Path] = nil end
	end)
	-- Acquire the scope before further allocations; a partial popup also rolls back.
	local ok, problem = protected(function()
		corner(app, root, 6, owned)
		local choices: { string } = record.Model.Values
		for index, value in choices do
			local button = create(app, "TextButton", "Option_" .. index, root, Layers.Popup, {
				Position = UDim2.fromOffset(4, 4+(index-1)*Appearance.OptionHeight),
				Size = UDim2.new(1, -8, 0, Appearance.OptionHeight), Text = "", AutoButtonColor = false, Selectable = false,
			}, owned) :: TextButton
			corner(app, button, 4, owned)
			local label = create(app, "TextLabel", "Value", button, Layers.Popup, {
				Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = value, FontFace = CONTROL_FACE,
				TextSize = 11, TextColor3 = Appearance.Value, TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true, TextTruncate = Enum.TextTruncate.None, BackgroundTransparency = 1,
			}, owned) :: TextLabel
			local option: DropdownOptionView = { Value = value, Button = button, Label = label, Height = Appearance.OptionHeight }
			table.insert(popup.Options, option)
			Resources.connect(owned, label:GetPropertyChangedSignal("AbsoluteSize"), function()
				if popup.Closing or app._interaction.Popup ~= popup then return end
				local height = math.max(Appearance.OptionHeight, math.ceil(label.AbsoluteSize.Y) + 12)
				if option.Height ~= height then option.Height = height; Controls.placePopup(popup) end
			end)
			Resources.connect(owned, button.MouseEnter, function() if popup.Closing then return end; popup.Hovered = button; Controls.paintPopup(popup) end)
			Resources.connect(owned, button.MouseLeave, function() if popup.Hovered == button then popup.Hovered = nil end; Controls.paintPopup(popup) end)
			Resources.connect(owned, button.Activated, function()
				if popup.Closing or app._interaction.Popup ~= popup or not Controls.interactive(record) then return end
				if record.Kind == "MultiDropdown" then
					local selection = (record.Handle :: MultiDropdownHandle):Get()
					local index = table.find(selection, value)
					if index then table.remove(selection, index) else table.insert(selection, value) end
					(record.Handle :: MultiDropdownHandle):Set(selection)
				else
					Controls.closePopup(app); (record.Handle :: DropdownHandle):Set(value)
				end
			end)
		end
		Resources.connect(owned, root.Destroying, function() Resources.close(owned) end)
		Resources.connect(owned, (record.Gui.Field :: TextButton):GetPropertyChangedSignal("AbsolutePosition"), function() Controls.placePopup(popup) end)
		Resources.connect(owned, (record.Gui.Field :: TextButton):GetPropertyChangedSignal("AbsoluteSize"), function() Controls.placePopup(popup) end)
		Resources.connect(owned, (app._view.Overlay :: Frame):GetPropertyChangedSignal("AbsoluteSize"), function() Controls.placePopup(popup) end)
		local rootSection = if record.Section.Kind == "MiniSection" then record.Section.RootSection else record.Section
		Resources.connect(owned, (Sections.container(app, rootSection.Tab) :: ScrollingFrame):GetPropertyChangedSignal("CanvasPosition"), function() Controls.closePopup(app) end)
		Controls.paintPopup(popup)
		if record.Gui.Chevron then Motion.to(app,record.Scope,record.Gui.Chevron,{Rotation=0},0.10) end
		Controls.placePopup(popup)
		if app._interaction.Popup == popup then Motion.popup(app,popup,false) end
	end)
	if not ok then Controls.closePopup(app,true); diagnostic("dropdown popup: " .. tostring(problem)) end
end
function Dropdown.Get(self: DropdownInternal): string return self._record.Model.Value end
function Dropdown.GetMetadata(self: DropdownInternal): ControlMetadata return self._record.Metadata end
function Dropdown.GetButton(self: DropdownInternal): TextButton? return self._record.Gui.Field end
function Dropdown.IsDestroyed(self: DropdownInternal): boolean return self._record.Scope.Closed end
function Dropdown.Destroy(self: DropdownInternal) if not self._record.Scope.Closed then Controls.remove(self._record) end end
function Dropdown.Set(self: DropdownInternal, value: string, options: ValueSetOptions?): ()
	local record = self._record
	Controls.options(options)
	if record.Owner._background.Selection == record and type(value) == "string" and value ~= "Default" then
		Background.path(value)
		if not record.Scope.Closed and not table.find(record.Model.Values, value) then
			local choices = table.clone(record.Model.Values); table.insert(choices, value)
			record.Model.Values = table.freeze(choices)
		end
	end
	assert(type(value) == "string" and table.find(record.Model.Values, value), "Dropdown value must exist in Values")
	if record.Scope.Closed or (record.Model.Value == value and not (options and options.Replay)) then return end
	record.Model.Value = value; Controls.paintDropdown(record)
	if record.Owner._background.Selection == record then Background.select(record.Owner) end
	Controls.emit(record, value, options)
end
function Dropdown.SetValues(self: DropdownInternal, values: { string }, options: ValueSetOptions?): ()
	Controls.options(options)
	local copy, record = Controls.validateValues(values), self._record
	if record.Scope.Closed then return end
	if record.Owner._interaction.Popup and record.Owner._interaction.Popup.Record == record then Controls.closePopup(record.Owner) end
	if Controls.sameArray(copy, record.Model.Values) then return end
	-- Default is the immutable creation snapshot, independent of later choices.
	record.Model.Values = copy
	if not table.find(copy, record.Model.Value) then self:Set(copy[1], options) end
end
function Controls.buildDropdown(record: SelectRecord, order: number): ()
	local app = record.Owner
	Controls.field(record, order, Appearance.DropdownWidth, Appearance.ControlHeight)
	local valueLabel = record.Gui.ValueLabel :: TextLabel
	valueLabel.Position, valueLabel.Size = UDim2.fromOffset(8, 0), UDim2.new(1, -29, 1, 0)
	record.Gui.Chevron = create(app, "ImageLabel", "Chevron", record.Gui.Field, Layers.Content, {
		AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(13,13),
		Image = app._icons.DropdownAsset or "", Rotation = 180, ImageColor3 = Appearance.Value, BackgroundTransparency = 1,
	}, record.Scope)
	Controls.paintDropdown(record)
	for _, property in { "AbsoluteSize", "FontFace", "TextSize" } do
		Resources.connect(record.Scope, valueLabel:GetPropertyChangedSignal(property), function() Controls.measureSummary(record) end)
	end
	Resources.connect(record.Scope, (record.Gui.Field :: TextButton).Activated, function() Controls.openDropdown(record) end)
end
function Section.AddDropdown(self: SectionInternal | MiniInternal, options: DropdownOptions): DropdownHandle
	local section, app = self._record, self._record.Owner
	local metadata = Controls.metadata(section, options)
	local values = Controls.validateValues(options.Values)
	local initial = if options.Default == nil then values[1] else options.Default
	assert(type(initial) == "string" and table.find(values, initial), "Dropdown Default must exist in Values")
	assert(options.Callback == nil or type(options.Callback) == "function", "Dropdown Callback requires function")
	local record: DropdownRecord = { Kind = "Dropdown", Gui={}, Metadata = metadata, Model = { Kind = "Dropdown", Metadata = metadata, Values = values, Default = initial, Value = initial },
		Scope = scope(), Owner = app, Section = section, Callback = options.Callback, Text = { Cache = {}, Count = 0 } }
	local handle = Controls.mount(record, Dropdown, function(order) Controls.buildDropdown(record, order) end)
	if app._life.Phase == "ready" and not app._icons.DropdownStarted then Resources.spawn(app._icons.Scope, function() Controls.loadDropdownIcon(app) end) end
	return handle
end
-- Selection arrays are canonical in Values order; callers and callbacks get copies.
function Controls.multiValues(values: { string }): { string }
	assert(type(values) == "table", "MultiDropdown Values require a string array")
	return if next(values) == nil then table.freeze({}) else Controls.validateValues(values)
end
function Controls.selection(values: { string }, input: { string }): { string }
	assert(type(input) == "table", "MultiDropdown selection requires a dense string array")
	local count, wanted = 0, {} :: { [string]: boolean }
	local allowed: { [string]: boolean } = {}
	for _, value in values do allowed[value] = true end
	for key, value in next, input do
		assert(type(key) == "number" and key % 1 == 0 and key >= 1 and key <= #input, "MultiDropdown selection requires a dense array")
		assert(type(value) == "string" and allowed[value], "MultiDropdown value must exist in Values")
		wanted[value] = true; count += 1
	end
	assert(count == #input, "MultiDropdown selection requires a dense array")
	local result: { string } = {}
	for _, value in values do if wanted[value] then table.insert(result, value) end end
	return table.freeze(result)
end
function Controls.sameArray(left: { string }, right: { string }): boolean
	if #left ~= #right then return false end
	for index, value in left do if value ~= right[index] then return false end end
	return true
end
function MultiDropdown.Get(self: MultiDropdownInternal): { string } return table.clone(self._record.Model.Value) end
function MultiDropdown.GetMetadata(self: MultiDropdownInternal): ControlMetadata return self._record.Metadata end
function MultiDropdown.GetButton(self: MultiDropdownInternal): TextButton? return self._record.Gui.Field end
function MultiDropdown.IsDestroyed(self: MultiDropdownInternal): boolean return self._record.Scope.Closed end
function MultiDropdown.Destroy(self: MultiDropdownInternal) if not self._record.Scope.Closed then Controls.remove(self._record) end end
function MultiDropdown.Set(self: MultiDropdownInternal, input: { string }, options: ValueSetOptions?): ()
	Controls.options(options)
	local record = self._record
	local selection = Controls.selection(record.Model.Values, input)
	if record.Scope.Closed then return end
	if Controls.sameArray(selection, record.Model.Value) and not (options and options.Replay) then return end
	record.Model.Value = selection; Controls.paintDropdown(record)
	Controls.emit(record, selection, options)
end
function MultiDropdown.SetValues(self: MultiDropdownInternal, values: { string }, options: ValueSetOptions?): ()
	Controls.options(options)
	local copy, record = Controls.multiValues(values), self._record
	if record.Scope.Closed then return end
	if record.Owner._interaction.Popup and record.Owner._interaction.Popup.Record == record then Controls.closePopup(record.Owner) end
	if Controls.sameArray(copy, record.Model.Values) then return end
	local retained: { string } = {}
	local selected: { [string]: boolean } = {}
	for _, value in record.Model.Value do selected[value] = true end
	for _, value in copy do if selected[value] then table.insert(retained, value) end end
	record.Model.Values = copy
	self:Set(retained, options)
end
function Section.AddMultiDropdown(self: SectionInternal | MiniInternal, options: MultiDropdownOptions): MultiDropdownHandle
	local section, app = self._record, self._record.Owner
	local metadata = Controls.metadata(section, options)
	local values = Controls.multiValues(options.Values)
	local initial = Controls.selection(values, if options.Default == nil then {} else options.Default)
	assert(options.Callback == nil or type(options.Callback) == "function", "MultiDropdown Callback requires function")
	local record: MultiDropdownRecord = { Kind = "MultiDropdown", Gui={}, Metadata = metadata, Model = { Kind = "MultiDropdown", Metadata = metadata, Values = values, Default = initial, Value = initial },
		Scope = scope(), Owner = app, Section = section, Callback = options.Callback, Text = { Cache = {}, Count = 0 } }
	local handle = Controls.mount(record, MultiDropdown, function(order) Controls.buildDropdown(record, order) end)
	if app._life.Phase == "ready" and not app._icons.DropdownStarted then Resources.spawn(app._icons.Scope, function() Controls.loadDropdownIcon(app) end) end
	return handle
end

-- Action buttons have a separate owner and never enter ControlValues/Flags.
function Controls.actionSurface(app: App, field: TextButton, disabled: boolean, pressed: boolean, hovered: boolean, flashing: boolean): ()
	field.BackgroundColor3 = if flashing then Colors.accent(app) elseif pressed then Appearance.Selected elseif hovered then Appearance.HoverButton else Appearance.Field
	Motion.alpha(app, field, "BackgroundTransparency", if disabled then 0.5 else 0.2)
end
function Controls.flash(owner: Scope, finish: () -> ()): ()
	Resources.spawn(owner, function()
		task.wait(ButtonStyle.FlashSeconds)
		if not owner.Closed then finish() end
	end)
end
function Controls.paintButton(record: ButtonRecord): ()
	local field = record.Gui.Field
	if not field or record.Scope.Closed then return end
	local disabled = record.Disabled or record.Completed
	field.Active = not disabled and not record.Busy
	Controls.actionSurface(record.Owner, field, disabled, record.Pressed, record.Hovered, record.Flashing)
	if record.Gui.Label then record.Gui.Label.TextColor3 = if disabled then Appearance.MutedText else Appearance.White end
	if record.Gui.Icon then
		record.Gui.Icon.Visible = record.Status == nil
		record.Gui.Icon.ImageColor3 = if disabled then Appearance.MutedText elseif record.Flashing then Colors.contrast(Colors.accent(record.Owner)) else Colors.accent(record.Owner)
		record.Gui.Icon.ImageTransparency = if record.Busy then 0.45 else 0
	end
	if record.Gui.ValueLabel then
		record.Gui.ValueLabel.Visible = record.Status ~= nil
		record.Gui.ValueLabel.Text = record.Status or ""
		record.Gui.ValueLabel.TextColor3 = if record.Flashing then Colors.contrast(Colors.accent(record.Owner)) else Appearance.Value
	end
end
function Controls.pressButton(record: ButtonRecord): boolean
	local app = record.Owner
	if record.Scope.Closed or app._life.Phase ~= "ready" or app._preferences.Restoring
		or app._env.Globals[RELOAD_SLOT] or record.Disabled or record.Completed or record.Busy then return false end
	record.Revision += 1
	local revision, run, feedback = record.Revision, scope(), scope()
	if record.Feedback then Resources.close(record.Feedback) end
	record.Run, record.Feedback = run, feedback
	record.Busy, record.Flashing, record.Pressed, record.Status = true, true, false, nil
	Resources.own(record.Scope, run); Resources.own(record.Scope, feedback)
	Resources.add(run, function() if record.Run == run then record.Run = nil; record.Busy = false end end)
	Resources.add(feedback, function() if record.Feedback == feedback then record.Feedback = nil; record.Flashing = false end end)
	local function current(): boolean
		return not record.Scope.Closed and not run.Closed and record.Run == run and record.Revision == revision and alive(app)
	end
	Controls.paintButton(record)
	Controls.flash(feedback, function()
		if feedback.Closed or record.Scope.Closed or record.Revision ~= revision then return end
		record.Flashing = false
		Controls.paintButton(record)
		if record.Completed then Resources.close(feedback) end
	end)
	local callback = record.Callback
	local function invoke(): ()
		if not current() then return end
		local ok, result = true, nil
		if callback then ok, result = protected(callback) end
		if not current() then return end
		record.Status = if not ok then "Error" elseif type(result) == "string" then result else "Done"
		record.Completed = ok and not record.Repeatable
		if not ok then diagnostic("button " .. record.Metadata.Path .. " callback: " .. tostring(result)) end
		Resources.close(run)
		Controls.paintButton(record)
		if record.Completed then
			if not record.Flashing then Resources.close(feedback) end
		else
			Resources.spawn(feedback, function()
				task.wait(1.75)
				if feedback.Closed or record.Scope.Closed or record.Revision ~= revision then return end
				record.Status = nil
				Resources.close(feedback)
				Controls.paintButton(record)
			end)
		end
	end
	-- Lifecycle calls must outlive destruction of the old button/menu. Their
	-- caller thread is deliberately not registered in the button's task owner.
	if record.Inline then invoke() else Resources.spawn(run, invoke) end
	return true
end
function Button.GetMetadata(self: ButtonInternal): ControlMetadata return self._record.Metadata end
function Button.GetButton(self: ButtonInternal): TextButton? return self._record.Gui.Field end
function Button.IsDestroyed(self: ButtonInternal): boolean return self._record.Scope.Closed end
function Button.IsDisabled(self: ButtonInternal): boolean return self._record.Disabled or self._record.Completed end
function Button.IsBusy(self: ButtonInternal): boolean return self._record.Busy end
function Button.IsCompleted(self: ButtonInternal): boolean return self._record.Completed end
function Button.Press(self: ButtonInternal): boolean return Controls.pressButton(self._record) end
function Button.SetDisabled(self: ButtonInternal, disabled: boolean): ()
	assert(type(disabled) == "boolean", "Button Disabled requires boolean")
	local record = self._record
	if record.Scope.Closed then return end
	record.Disabled, record.Hovered, record.Pressed = disabled, false, false
	Controls.paintButton(record)
end
function Button.Destroy(self: ButtonInternal) if not self._record.Scope.Closed then Controls.remove(self._record) end end
function Controls.addButton(section: ControlHost, options: ButtonOptions, inline: boolean?): ButtonHandle
	local app = section.Owner
	local metadata = Controls.metadata(section, { Id = options.Id, Name = options.Name, Flag = nil })
	assert(options.Callback == nil or type(options.Callback) == "function", "Button Callback requires function")
	assert(options.Disabled == nil or type(options.Disabled) == "boolean", "Button Disabled requires boolean")
	assert(options.Repeatable == nil or type(options.Repeatable) == "boolean", "Button Repeatable requires boolean")
	assert(options.Icon == nil or type(options.Icon) == "string", "Button Icon requires string")
	local iconSource = Icons.source(options.Icon or BUTTON_ACTION_ICON)
	local record: ButtonRecord = { Kind = "Button", Gui={}, Metadata = metadata, Callback = options.Callback,
		IconSource = iconSource, IconOutcome = if app._icons.ButtonAssets[iconSource] then "memory" else "pending",
		Disabled = options.Disabled == true, Repeatable = options.Repeatable ~= false, Completed = false, Busy = false,
		Inline = inline == true, Revision = 0, Flashing = false,
		Hovered = false, Pressed = false, Scope = scope(), Owner = app, Section = section }
	local handle = Controls.mount(record, Button, function(order)
		Controls.field(record, order, ButtonStyle.Width, ButtonStyle.Height)
		local row, field = record.Gui.Row :: Frame, record.Gui.Field :: TextButton
		local valueLabel = record.Gui.ValueLabel :: TextLabel
		valueLabel.Position, valueLabel.Size = UDim2.fromOffset(3, 0), UDim2.new(1, -6, 1, 0)
		valueLabel.TextXAlignment = Enum.TextXAlignment.Center
		record.Gui.Icon = create(app, "ImageLabel", "Icon", field, Layers.Content, {
			AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(ButtonStyle.Icon,ButtonStyle.Icon),
			Image=app._icons.ButtonAssets[iconSource] or "",BackgroundTransparency=1,ImageColor3=Appearance.Value,ScaleType=Enum.ScaleType.Fit,
		}, record.Scope)
		Resources.connect(record.Scope, field.MouseEnter, function()
			record.Hovered = not record.Disabled and not record.Completed and not record.Busy and Controls.interactive(record); Controls.paintButton(record)
		end)
		Resources.connect(record.Scope, field.MouseLeave, function()
			record.Hovered, record.Pressed = false, false; Controls.paintButton(record)
		end)
		Resources.connect(record.Scope, field.MouseButton1Down, function()
			record.Pressed = not record.Disabled and not record.Completed and not record.Busy and Controls.interactive(record); Controls.paintButton(record)
		end)
		Resources.connect(record.Scope, field.MouseButton1Up, function() record.Pressed = false; Controls.paintButton(record) end)
		Resources.connect(record.Scope, field.Activated, function(event)
			record.Pressed = false; Controls.paintButton(record)
			if field.Parent~=row or not field.Visible or Mini.gearHit(record,event) or record.Disabled or not Controls.interactive(record) or app._interaction.Assignment or app._interaction.ConsumedPointer then return end
			Controls.closePopup(app)
			Controls.pressButton(record)
		end)
		Resources.connect(record.Scope, row.AncestryChanged, function() if row.Parent ~= section.Body then record.Hovered, record.Pressed = false, false; Controls.paintButton(record) end end)
		Resources.connect(record.Scope, row:GetPropertyChangedSignal("Visible"), function() if not Controls.interactive(record) then record.Hovered, record.Pressed = false, false; Controls.paintButton(record) end end)
		Controls.paintButton(record)
	end)
	if app._life.Phase == "ready" and record.IconOutcome == "pending" then Resources.spawn(app._icons.Scope, function() Controls.loadButtonIcon(app) end) end
	return handle
end
function Section.AddButton(self: SectionInternal | MiniInternal, options: ButtonOptions): ButtonHandle
	return Controls.addButton(self._record, options)
end
function Controls.validKey(value: EnumItem?): boolean
	if value == nil then return true end
	if typeof(value) ~= "EnumItem" then return false end
	if value.EnumType == Enum.KeyCode then
		return value ~= Enum.KeyCode.Unknown and value ~= Enum.KeyCode.Escape
			and not value.Name:match("^Button") and not value.Name:match("^DPad") and not value.Name:match("^Thumbstick")
	end
	return value.EnumType == Enum.UserInputType and value.Name:match("^MouseButton%d+$") ~= nil
end
local KEY_NAMES = table.freeze({
	LeftControl="LCtl",RightControl="RCtl",LeftShift="LSh",RightShift="RSh",LeftAlt="LAlt",RightAlt="RAlt",
	LeftMeta="LMet",RightMeta="RMet",LeftSuper="LSup",RightSuper="RSup",Backspace="Bksp",CapsLock="Caps",
	Insert="Ins",Delete="Del",PageUp="PgUp",PageDown="PgDn",Return="Ent",Space="Spc",Print="Prt",
	ScrollLock="Scrl",NumLock="Num",Up="Up",Down="Dn",Left="Lt",Right="Rt",Pause="Paus",
	LeftBracket="[",RightBracket="]",BackSlash="\\",Slash="/",Semicolon=";",Quote="'",Backquote="`",Period=".",Comma=",",
	Minus="-",Equals="=",KeypadEnter="KEnt",KeypadPlus="K+",KeypadMinus="K-",KeypadMultiply="K*",KeypadDivide="K/",KeypadPeriod="K.",
})
function Controls.paintKeybind(record: KeybindRecord): ()
	if record.Scope.Closed or not record.Gui.ValueLabel then return end
	Controls.fieldAccent(record)
	local value = record.Model.Value
	record.Gui.ValueLabel.Text = if record.Owner._interaction.Assignment == record then "…" else
		(if value then KEY_NAMES[value.Name] or value.Name:gsub("^MouseButton","M"):gsub("^Keypad","K") else "N/A")
	if record.Gui.Field and record.Gui.Label then
		-- TextBounds reflects an already truncated label. Measure the full key
		-- name so a narrow initial field cannot lock RightShift into an ellipsis.
		local bounds = (game:GetService("TextService") :: TextService):GetTextSize(record.Gui.ValueLabel.Text, record.Gui.ValueLabel.TextSize, Enum.Font.JosefinSans, Vector2.new(10000,24))
		local width = math.clamp(math.ceil(bounds.X)+8, 20, 50)
		record.Gui.Field.Size = UDim2.fromOffset(width, 20)
		record.Gui.Label.Size = UDim2.new(1, -width-10-Mini.gearSpace(record), 1, 0)
		Mini.placeGear(record)
	end
end
function Keybind.Get(self: KeybindInternal): EnumItem? return self._record.Model.Value end
function Keybind.GetMetadata(self: KeybindInternal): ControlMetadata return self._record.Metadata end
function Keybind.GetButton(self: KeybindInternal): TextButton? return self._record.Gui.Field end
function Keybind.IsDestroyed(self: KeybindInternal): boolean return self._record.Scope.Closed end
function Keybind.Destroy(self: KeybindInternal) if not self._record.Scope.Closed then Controls.remove(self._record) end end
function Keybind.Set(self: KeybindInternal, value: EnumItem?, options: ValueSetOptions?): ()
	Controls.options(options); assert(Controls.validKey(value), "Keybind requires keyboard key, mouse button, or nil; Escape is reserved")
	local record = self._record
	if record.Scope.Closed then return end
	if record.Owner._interaction.Assignment == record then Controls.cancelAssignment(record.Owner) end
	if record.Model.Value == value and not (options and options.Replay) then return end
	record.Model.Value = value; Controls.paintKeybind(record)
	Controls.emit(record, value, options)
end
function Section.AddKeybind(self: SectionInternal | MiniInternal, options: KeybindOptions): KeybindHandle
	local section, app = self._record, self._record.Owner
	local metadata = Controls.metadata(section, options)
	assert(Controls.validKey(options.Default), "Keybind Default requires keyboard key, mouse button, or nil")
	assert(options.Callback == nil or type(options.Callback) == "function", "Keybind Callback requires function")
	local record: KeybindRecord = { Kind = "Keybind", Gui={}, Metadata = metadata, Model = { Kind = "Keybind", Metadata = metadata, Default = options.Default, Value = options.Default }, Scope = scope(), Owner = app,
		Section = section, Callback = options.Callback }
	local handle = Controls.mount(record, Keybind, function(order)
		Controls.field(record, order, 20, 20)
		local valueLabel = record.Gui.ValueLabel :: TextLabel
		valueLabel.Position, valueLabel.Size = UDim2.fromOffset(4,0), UDim2.new(1,-8,1,0)
		valueLabel.TextXAlignment = Enum.TextXAlignment.Center
		Controls.paintKeybind(record)
		Resources.connect(record.Scope, (record.Gui.ValueLabel :: TextLabel):GetPropertyChangedSignal("TextBounds"), function() Controls.paintKeybind(record) end)
		Resources.connect(record.Scope, (record.Gui.Field :: TextButton).Activated, function(event)
			if event ~= nil and event == record.CapturedInput then record.CapturedInput = nil; return end
			if app._interaction.Assignment or not Controls.interactive(record) then return end
			Controls.cancel(app); app._interaction.Assignment = record; Controls.paintKeybind(record)
		end)
	end)
	return handle
end
function Controls.input(app: App, event: InputObject): boolean
	local interaction, env = app._interaction, app._env
	local editor=interaction.Editor
	if editor then
		if not Controls.interactive(editor) then Sliders.finish(editor,false)
		elseif event.KeyCode==Enum.KeyCode.Escape then Sliders.finish(editor,false);return true
		elseif event.KeyCode==Enum.KeyCode.Return or event.KeyCode==Enum.KeyCode.KeypadEnter then Sliders.finish(editor,true);return true end
	end
	local assignment = interaction.Assignment
	if assignment then
		if not Controls.available(assignment) or env.Input:GetFocusedTextBox() then Controls.cancelAssignment(app); return true end
		if event.KeyCode == Enum.KeyCode.Escape then
			Controls.cancelAssignment(app); (assignment.Handle :: KeybindHandle):Set(nil); return true
		end
		local value = if event.UserInputType == Enum.UserInputType.Keyboard then event.KeyCode else event.UserInputType
		if Controls.validKey(value) then
			assignment.CapturedInput = if event.UserInputType == Enum.UserInputType.Keyboard then nil else event
			if event.UserInputType ~= Enum.UserInputType.Keyboard then interaction.ConsumedPointer = event end
			Controls.cancelAssignment(app); (assignment.Handle :: KeybindHandle):Set(value)
		end
		return true -- including RightShift: the assignment owns this press
	end
	if event.KeyCode == Enum.KeyCode.Escape and (interaction.Color or interaction.Popup or #app._minis.Chain > 0) then
		Mini.closeBranch(app,1);Colors.close(app);Controls.closePopup(app);return true
	end
	if Floating.pointer(event) then
		local at=Vector2.new(event.Position.X,event.Position.Y)
		if not Mini.inside(app,at) then Mini.closeBranch(app,1) end
		local color=interaction.Color
		if color and not Controls.contains(color.Root,at) and not Controls.contains(color.Record.Gui.Field,at) then Colors.close(app) end
	end
	local popup = interaction.Popup
	if popup then
		if event.KeyCode == Enum.KeyCode.Escape then Controls.closePopup(app); return true end
		if event.UserInputType == Enum.UserInputType.Touch or event.UserInputType.Name:match("^MouseButton") then
			local at = Vector2.new(event.Position.X,event.Position.Y)
			-- The field belongs to Gui. Keep this same field press until Activated
			-- toggles the popup; closing on InputBegan would immediately reopen it.
			if not Controls.contains(popup.Root,at) and not Controls.contains(popup.Record.Gui.Field,at) then Controls.closePopup(app) end
		end
	end
	return false
end
function Controls.loadDropdownIcon(app: App): ()
	if not alive(app) then return end
	if app._icons.DropdownStarted then return end
	local needed = app._configs.Chevron ~= nil
	for _, collection in app._values.BySection do
		for _, record in collection.Order do if (record.Kind == "Dropdown" or record.Kind == "MultiDropdown") and not record.Scope.Closed then needed = true; break end end
	end
	if not needed then return end
	app._icons.DropdownStarted, app._icons.DropdownOutcome = true, "pending"
	local asset, outcome = Icons.load(app, Icons.source(DROPDOWN_ICON), app._icons.Scope, "dropdown arrow")
	if not alive(app) then return end
	app._icons.DropdownAsset, app._icons.DropdownOutcome = asset, outcome
	if not asset then app:_fail("required dropdown arrow unavailable"); return end
	if app._configs.Chevron then app._configs.Chevron.Image = asset end
	for _, collection in app._values.BySection do
		for _, record in collection.Order do if (record.Kind == "Dropdown" or record.Kind == "MultiDropdown") and record.Gui.Chevron then record.Gui.Chevron.Image = asset end end
	end
end

function Controls.loadButtonIcon(app: App): ()
	if not alive(app) then return end
	for _, record in app._buttons.ByPath do
		if record.IconOutcome ~= "pending" then continue end
		local source = record.IconSource
		record.IconOutcome = "loading"
		local asset, outcome = Icons.load(app, source, app._icons.Scope, "button action icon")
		if not alive(app) then return end
		if not asset then app:_fail("required button action icon unavailable: " .. source); return end
		app._icons.ButtonAssets[source] = asset
		for _, consumer in app._buttons.ByPath do
			if consumer.IconSource == source then
				consumer.IconOutcome = outcome
				if consumer.Gui.Icon then consumer.Gui.Icon.Image = asset end
			end
		end
	end
end

-- Shared host routing and floating ownership. Mini panels never enter SectionArea.
function Controls.layout(host: ControlHost): ()
	Modes.invalidate(host.Owner)
	if host.Kind == "MiniSection" then Mini.layout(host) else Sections.request(host.Owner) end
end
function Mini.belongs(host: ControlHost, ancestor: ControlHost): boolean
	if host == ancestor then return true end
	if host.Kind ~= "MiniSection" then return false end
	if ancestor.Kind == "Section" then return host.RootSection == ancestor end
	local parent = host.Parent
	while parent do if parent == ancestor then return true end; parent = parent.Parent end
	return false
end
function Mini.hostVisible(host: ControlHost): boolean
	if host.Scope.Closed then return false end
	if host.Kind == "Section" then return Sections.interactive(host) and not Modes.collapsed(host) and host.Root ~= nil and host.Root.Visible end
	local owner = host.OwnerControl
	return host.Open and host.Root ~= nil and host.Root.Visible and not owner.Scope.Closed
		and owner.Gui.Row ~= nil and owner.Gui.Row.Visible and owner.Gui.Row.Parent == owner.Section.Body and Mini.hostVisible(owner.Section)
end
function Mini.gearSpace(record: ControlView): number
	return if record.Owner._minis.ByControl[record.Metadata.Path] then MiniStyle.GearWidth + MiniStyle.GearGap else 0
end
function Mini.gearHit(record: ControlView, event: InputObject?): boolean
	local node = record.Owner._minis.ByControl[record.Metadata.Path]
	return event ~= nil and node ~= nil and Controls.contains(node.Gear, Vector2.new(event.Position.X,event.Position.Y))
end
function Mini.placeGear(record: ControlView): ()
	local node = record.Owner._minis.ByControl[record.Metadata.Path]
	if not node or not node.Gear then return end
	local width = if record.Kind == "Toggle" then Appearance.ToggleWidth elseif record.Gui.Field then record.Gui.Field.Size.X.Offset else 0
	node.Gear.Position = if record.Kind=="Slider" then UDim2.new(1,-width-MiniStyle.GearGap,0,SliderStyle.HeaderY+SliderStyle.Header/2) else UDim2.new(1,-width-MiniStyle.GearGap,0.5,0)
	if record.Kind=="Slider" then node.Gear.Size=UDim2.fromOffset(MiniStyle.GearWidth,SliderStyle.Header) end
	if node.GearImage then node.GearImage.Size = UDim2.fromScale(MiniStyle.Icon/node.Gear.Size.X.Offset,MiniStyle.Icon/node.Gear.Size.Y.Offset) end
end
function Floating.anchorVisible(record: ControlView, anchor: GuiObject): boolean
	if not Controls.interactive(record) then return false end
	local ap, az = anchor.AbsolutePosition, anchor.AbsoluteSize
	local cursor: Instance? = anchor
	while cursor and cursor ~= record.Owner.ScreenGui do
		if cursor:IsA("GuiObject") then
			if not cursor.Visible then return false end
			if cursor.ClipsDescendants then
				local p = cursor.AbsolutePosition
				local z = if cursor:IsA("ScrollingFrame") then cursor.AbsoluteWindowSize else cursor.AbsoluteSize
				if ap.X < p.X or ap.Y < p.Y or ap.X+az.X > p.X+z.X or ap.Y+az.Y > p.Y+z.Y then return false end
			end
		end
		cursor = cursor.Parent
	end
	local screen = record.Owner.ScreenGui
	return screen ~= nil and cursor == screen and screen.Enabled
end
function Floating.clamp(app: App, position: Vector2, size: Vector2, margin: number): Vector2
	local bounds = if app._view.Overlay then app._view.Overlay.AbsoluteSize else app._geometry.Viewport
	return Vector2.new(math.clamp(position.X,math.min(margin,bounds.X/2),math.max(math.min(margin,bounds.X/2),bounds.X-size.X-margin)),
		math.clamp(position.Y,math.min(margin,bounds.Y/2),math.max(math.min(margin,bounds.Y/2),bounds.Y-size.Y-margin)))
end
function Floating.matches(pointer: InputObject, event: InputObject, ended: boolean?): boolean
	return pointer == event or (pointer.UserInputType == Enum.UserInputType.MouseButton1
		and event.UserInputType == (if ended then Enum.UserInputType.MouseButton1 else Enum.UserInputType.MouseMovement))
end
function Floating.hit(app: App, at: Vector2): boolean
	local popup, color = app._interaction.Popup, app._interaction.Color
	if app._configs.Popup and Controls.contains(app._configs.Popup, at) then return true end
	if popup and Controls.contains(popup.Root,at) then return true end
	if color and Controls.contains(color.Root,at) then return true end
	for _, node in app._minis.Chain do if Controls.contains(node.Root,at) or Controls.contains(node.Gear,at) then return true end end
	return false
end
function Mini.inside(app: App, at: Vector2): boolean
	for _, node in app._minis.Chain do
		if Controls.contains(node.Root,at) or Controls.contains(node.Gear,at) then return true end
	end
	local popup, color = app._interaction.Popup, app._interaction.Color
	if popup and popup.Record.Section.Kind == "MiniSection" and Controls.contains(popup.Root,at) then return true end
	if color and color.Record.Section.Kind == "MiniSection" and Controls.contains(color.Root,at) then return true end
	return false
end
function Mini.closeBranch(app: App, depth: number): ()
	local chain = app._minis.Chain
	for index = #chain, depth, -1 do
		local node = table.remove(chain,index) :: MiniRecord
		node.Open = false
		local gesture = app._interaction.Surface
		if gesture and gesture.Mini == node then app._interaction.Surface = nil end
		Controls.cancel(app,node)
		if node.Root then node.Root.Visible = false end
	end
end
function Mini.closeHost(app: App, host: ControlHost): ()
	for depth = 1, #app._minis.Chain do
		local node = app._minis.Chain[depth]
		local section = node.OwnerControl.Section
		if Mini.belongs(section,host) then Mini.closeBranch(app,depth); return end
	end
end
function Mini.clampScroll(node: MiniRecord): ()
	local scroll = node.Scroll
	if node.Scope.Closed or not scroll then return end
	local maximum = math.max(0,scroll.CanvasSize.Y.Offset-scroll.AbsoluteWindowSize.Y)
	scroll.CanvasPosition = Vector2.new(0,math.clamp(scroll.CanvasPosition.Y,0,maximum))
end
function Mini.layout(node: MiniRecord): ()
	if node.Scope.Closed or not node.Root or not node.Scroll or not node.Body or not node.ContentLayout then return end
	local bounds = if node.Owner._view.Overlay then node.Owner._view.Overlay.AbsoluteSize else node.Owner._geometry.Viewport
	local height = math.max(0,math.ceil(node.ContentLayout.AbsoluteContentSize.Y))
	-- The clip window must include the 4 px slider thumb overhang and field strokes.
	-- Keep these edge insets outside UIListLayout's measurement and count them once.
	local insetY = if height > 0 then MiniStyle.ContentInset else 0
	local canvasHeight = height+insetY*2
	local width = math.min(MiniStyle.Width,math.max(0,bounds.X-MiniStyle.Margin*2))
	local total = math.min(MiniStyle.Header+12+canvasHeight,math.max(0,bounds.Y-MiniStyle.Margin*2))
	local padding = math.min(MiniStyle.Padding,width/2)
	local scrollWidth = math.max(0,width-padding*2)
	local insetX = math.min(MiniStyle.ContentInset,scrollWidth/2)
	local top = math.min(MiniStyle.Header+6,total)
	node.Root.Size = UDim2.fromOffset(width,total)
	if node.DragHandle then
		node.DragHandle.Size = UDim2.new(1,0,0,math.min(MiniStyle.HitHeight,total))
		local line = node.DragHandle:FindFirstChild("DragLine") :: Frame?
		if line then line.Size = UDim2.fromOffset(math.min(28,width),math.min(2,total)) end
	end
	node.Scroll.Position = UDim2.fromOffset(padding,top)
	node.Scroll.Size = UDim2.fromOffset(scrollWidth,math.max(0,total-top-6))
	node.Body.Position = UDim2.fromOffset(insetX,insetY)
	node.Body.Size = UDim2.new(1,-insetX*2,0,height)
	node.Scroll.CanvasSize = UDim2.fromOffset(0,canvasHeight)
	Mini.clampScroll(node)
	if node.Open then
		local at = node.Root.Position
		local p = Floating.clamp(node.Owner,Vector2.new(at.X.Offset,at.Y.Offset),Vector2.new(width,total),MiniStyle.Margin)
		node.Root.Position = UDim2.fromOffset(p.X,p.Y)
	end
end
function Mini.open(node: MiniRecord): ()
	local app = node.Owner
	if node.Scope.Closed or not node.Gear or not node.Root or not app._icons.GearAsset or not Controls.interactive(node.OwnerControl)
		or not Floating.anchorVisible(node.OwnerControl,node.Gear) then return end
	local depth = table.find(app._minis.Chain,node)
	if depth then Mini.closeBranch(app,depth); return end
	local parent = node.Parent
	local parentDepth = if parent then table.find(app._minis.Chain,parent) else 0
	if parentDepth == nil then return end
	Mini.closeBranch(app,parentDepth+1); Controls.cancel(app)
	Mini.layout(node)
	local overlay = app._view.Overlay :: Frame
	local anchor = node.Gear.AbsolutePosition-overlay.AbsolutePosition
	local left, right = anchor.X, anchor.X+node.Gear.AbsoluteSize.X
	local parentRoot = if parent then parent.Root else nil
	if parentRoot then
		left = parentRoot.AbsolutePosition.X-overlay.AbsolutePosition.X
		right = left+parentRoot.AbsoluteSize.X
	end
	local width, height = node.Root.Size.X.Offset,node.Root.Size.Y.Offset
	local x = right+MiniStyle.Gap
	if x+width > overlay.AbsoluteSize.X-MiniStyle.Margin then x = left-MiniStyle.Gap-width end
	local position = Floating.clamp(app,Vector2.new(x,anchor.Y),Vector2.new(width,height),MiniStyle.Margin)
	node.Root.Position = UDim2.fromOffset(position.X,position.Y)
	node.Open = true
	table.insert(app._minis.Chain,node)
	node.Root.Visible = true
end
function Mini.destroy(node: MiniRecord): ()
	if node.Scope.Closed or node.Destroying then return end
	node.Destroying = true
	local app, owner = node.Owner,node.OwnerControl
	local depth = table.find(app._minis.Chain,node)
	if depth then Mini.closeBranch(app,depth) end
	Controls.destroySection(node)
	Resources.close(node.Scope)
	app._minis.ByControl[owner.Metadata.Path] = nil
	local index = table.find(app._minis.Order,node); if index then table.remove(app._minis.Order,index) end
	if node.ReservedLabel and owner.Gui.Label and not owner.Scope.Closed then owner.Gui.Label.Size += UDim2.fromOffset(MiniStyle.GearWidth+MiniStyle.GearGap,0) end
	node.Root,node.Body,node.Scroll,node.ContentLayout,node.Gear,node.GearImage,node.DragHandle = nil,nil,nil,nil,nil,nil,nil
	Modes.invalidate(app)
end
function Mini.destroyAll(app: App): ()
	Mini.closeBranch(app,1)
	local nodes = table.clone(app._minis.Order)
	for index = 1, #nodes do
		local node = nodes[index]
		safe(function(): ...any Mini.destroy(node) end)
	end
	Resources.close(app._minis.Scope)
end
function Mini.loadIcon(app: App): ()
	if not alive(app) or app._icons.GearStarted or #app._minis.Order == 0 then return end
	app._icons.GearStarted,app._icons.GearOutcome = true,"pending"
	local asset,outcome = Icons.load(app,Icons.source(MINI_GEAR_ICON),app._icons.Scope,"mini-section gear")
	if not alive(app) then return end
	app._icons.GearAsset,app._icons.GearOutcome = asset,outcome
	if not asset then app:_fail("required mini-section gear unavailable"); return end
	for _, node in app._minis.Order do if node.GearImage then node.GearImage.Image = asset end end
end
function Mini.create(record: ControlView): MiniHandle
	assert(not record.Scope.Closed and alive(record.Owner),"Cannot create mini-section for destroyed control")
	local previous = record.Owner._minis.ByControl[record.Metadata.Path]
	if previous then return previous.Handle :: MiniHandle end
	local host,app = record.Section,record.Owner
	local parent = if host.Kind == "MiniSection" then host else nil
	local root = if parent then parent.RootSection else host :: SectionRecord
	local node: MiniRecord = { Kind="MiniSection",Owner=app,Tab=host.Tab,OwnerControl=record,Parent=parent,RootSection=root,
		Metadata=table.freeze({Id="mini",Name=record.Metadata.Name,TabId=record.Metadata.TabId,SectionId=root.Metadata.Id,
			Path=record.Metadata.Path.."/@mini",ParentControlId=record.Metadata.Id,ParentControlPath=record.Metadata.Path}),
		Scope=scope(),Open=false,Depth=if parent then parent.Depth+1 else 1,Destroying=false,ReservedLabel=false,NextControlOrder=0 }
	local handle: MiniInternal = table.freeze(setmetatable({_record=node},MiniSection)) :: any; node.Handle=handle
	app._minis.ByControl[record.Metadata.Path]=node;table.insert(app._minis.Order,node)
	Resources.own(record.Scope,node.Scope,function() Mini.destroy(node) end)
	Resources.own(app._minis.Scope,node.Scope,function() Mini.destroy(node) end)
	local ok,problem = protected(function()
		local owned = node.Scope
		node.Gear = create(app,"ImageButton","MiniSectionGear",record.Gui.Row,Layers.Content,{
			AnchorPoint=Vector2.new(1,0.5),Size=UDim2.fromOffset(MiniStyle.GearWidth,Appearance.ControlHeight),
			BackgroundTransparency=1,Image="",AutoButtonColor=false,Selectable=false,
		},owned)
		node.GearImage = create(app,"ImageLabel","Icon",node.Gear,Layers.Content,{
			AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(MiniStyle.Icon/MiniStyle.GearWidth,MiniStyle.Icon/Appearance.ControlHeight),
			BackgroundTransparency=1,Image=app._icons.GearAsset or "",ImageColor3=Colors.accent(app),ImageTransparency=0.15,
		},owned)
		if record.Gui.Label then record.Gui.Label.Size -= UDim2.fromOffset(MiniStyle.GearWidth+MiniStyle.GearGap,0);node.ReservedLabel=true end
		Mini.placeGear(record)
		if record.Kind ~= "Toggle" and record.Gui.Field then
			Resources.connect(owned,record.Gui.Field:GetPropertyChangedSignal("Size"),function() Mini.placeGear(record) end)
		end
		node.Root = create(app,"Frame","MiniSection",app._view.MiniLayer or app._view.Canvas,Layers.MiniSection+node.Depth,{
			Size=UDim2.fromOffset(MiniStyle.Width,MiniStyle.Header),BackgroundColor3=Appearance.Card,
			BackgroundTransparency=0.08,Visible=false,Active=true,ClipsDescendants=false,
		},owned)
		corner(app,node.Root :: Frame,8,owned)
		node.DragHandle=create(app,"TextButton","DragHandle",node.Root,Layers.Content,{
			Size=UDim2.new(1,0,0,MiniStyle.HitHeight),Text="",BackgroundTransparency=1,AutoButtonColor=false,Selectable=false,
		},owned)
		local line=create(app,"Frame","DragLine",node.DragHandle,Layers.Content,{
			AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(28,2),
			BackgroundColor3=Appearance.MutedText,BackgroundTransparency=0.45,
		},owned);corner(app,line,1,owned)
		node.Scroll=create(app,"ScrollingFrame","Content",node.Root,Layers.Content,{
			Position=UDim2.fromOffset(MiniStyle.Padding,MiniStyle.Header+6),BackgroundTransparency=1,
			ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,AutomaticCanvasSize=Enum.AutomaticSize.None,
			VerticalScrollBarInset=Enum.ScrollBarInset.None,ClipsDescendants=true,Active=true,ElasticBehavior=Enum.ElasticBehavior.Never,
		},owned)
		node.Body=create(app,"Frame","Body",node.Scroll,Layers.Content,{
			Size=UDim2.fromOffset(0,0),BackgroundTransparency=1,ClipsDescendants=false,
		},owned)
		node.ContentLayout=create(app,"UIListLayout","Flow",node.Body,nil,{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},owned)
		Resources.connect(owned,(node.ContentLayout :: UIListLayout):GetPropertyChangedSignal("AbsoluteContentSize"),function() Mini.layout(node) end)
		Resources.connect(owned,(node.Scroll :: ScrollingFrame):GetPropertyChangedSignal("AbsoluteWindowSize"),function() Mini.clampScroll(node) end)
		Resources.connect(owned,(app._view.Canvas :: Frame):GetPropertyChangedSignal("AbsoluteSize"),function() Mini.layout(node) end)
		Resources.connect(owned,(node.Gear :: ImageButton).MouseEnter,function() if Controls.interactive(record) and node.GearImage then node.GearImage.ImageTransparency=0 end end)
		Resources.connect(owned,(node.Gear :: ImageButton).MouseLeave,function() if node.GearImage then node.GearImage.ImageTransparency=0.15 end end)
		Resources.connect(owned,(node.Gear :: ImageButton).Activated,function() Mini.open(node) end)
		Resources.connect(owned,(node.DragHandle :: TextButton).InputBegan,function(event)
			if not node.Open or not Controls.interactive(record) or not Floating.pointer(event) then return end
			Controls.cancel(app);app._interaction.Surface={Kind="MiniDrag",Mini=node,Pointer=event,
				Origin=Vector2.new(event.Position.X,event.Position.Y),Position=Vector2.new((node.Root :: Frame).Position.X.Offset,(node.Root :: Frame).Position.Y.Offset)}
		end)
		local miniObjects: { Instance } = { node.Root :: Frame, node.Gear :: ImageButton }
		for _,object in miniObjects do Resources.connect(owned,object.Destroying,function() if not node.Scope.Closed then Mini.destroy(node) end end) end
		Resources.connect(owned,(node.Root :: Frame):GetPropertyChangedSignal("Visible"),function()
			if node.Root and not node.Root.Visible then local depth=table.find(app._minis.Chain,node);if depth then Mini.closeBranch(app,depth) end end
		end)
		Resources.connect(owned,((record.Gui.Row :: any) :: GuiObject):GetPropertyChangedSignal("Visible"),function() if record.Gui.Row and not record.Gui.Row.Visible then local depth=table.find(app._minis.Chain,node);if depth then Mini.closeBranch(app,depth) end end end)
		Resources.connect(owned,((record.Gui.Row :: any) :: GuiObject).AncestryChanged,function() if record.Gui.Row and record.Gui.Row.Parent ~= host.Body then local depth=table.find(app._minis.Chain,node);if depth then Mini.closeBranch(app,depth) end end end)
		Resources.connect(owned,(node.Scroll :: ScrollingFrame):GetPropertyChangedSignal("CanvasPosition"),function() Controls.cancel(app,node) end)
		Mini.layout(node)
	end)
	if not ok then Mini.destroy(node);error("MiniSection construction: "..tostring(problem),0) end
	if app._life.Phase=="ready" and not app._icons.GearStarted then Resources.spawn(app._icons.Scope,function() Mini.loadIcon(app) end) end
	Modes.invalidate(app)
	return handle
end
function MiniSection.GetMetadata(self: MiniInternal): HostMetadata return self._record.Metadata end
function MiniSection.GetContent(self: MiniInternal): Frame
	assert(not self._record.Scope.Closed and self._record.Body,"MiniSection is destroyed");return self._record.Body :: Frame
end
function MiniSection.GetRoot(self: MiniInternal): Frame? return self._record.Root end
function MiniSection.GetGear(self: MiniInternal): ImageButton? return self._record.Gear end
function MiniSection.GetDragHandle(self: MiniInternal): TextButton? return self._record.DragHandle end
function MiniSection.IsOpen(self: MiniInternal): boolean return self._record.Open end
function MiniSection.IsDestroyed(self: MiniInternal): boolean return self._record.Scope.Closed end
function MiniSection.Destroy(self: MiniInternal) Mini.destroy(self._record) end
function Floating.pointer(event: InputObject): boolean
	return event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch
end
function Floating.move(app: App, event: InputObject): ()
	local gesture=app._interaction.Surface
	if not gesture or not Floating.matches(gesture.Pointer,event) then return end
	local at=Vector2.new(event.Position.X,event.Position.Y)
	if gesture.Kind=="Slider" then
		local record=gesture.Slider
		if not record or not Controls.interactive(record) then app._interaction.Surface=nil;return end
		Sliders.pointer(record,at)
	elseif gesture.Kind=="MiniDrag" then
		local node=gesture.Mini
		if not node or not node.Open or not node.Root then app._interaction.Surface=nil;return end
		local position=Floating.clamp(app,gesture.Position+at-gesture.Origin,node.Root.AbsoluteSize,MiniStyle.Margin)
		node.Root.Position=UDim2.fromOffset(position.X,position.Y)
	else
		local popup=app._interaction.Color
		if not popup or popup.Record~=gesture.Color or not Controls.interactive(popup.Record) then app._interaction.Surface=nil;return end
		if gesture.Kind=="ColorDrag" then popup.ManualPosition=gesture.Position+at-gesture.Origin;Colors.place(popup)
		else Colors.pointer(popup,at,gesture.Kind=="Hue") end
	end
end

-- Color3 values and retained HSV intent belong to the control, not its popup.
function Colors.accent(app: App): Color3 return app._preferences.AccentColor end
function Colors.contrast(color: Color3): Color3
	return if color.R * 0.2126 + color.G * 0.7152 + color.B * 0.0722 > 0.5 then Appearance.Field else Appearance.White
end
function Colors.paintAccent(app: App): ()
	for _, tab in app._tabs.ById do Tabs.paint(tab, true) end
	for _, record in app._values.ByFlag do
		if record.Kind == "Toggle" then Controls.paint(record, true)
		elseif record.Kind == "Slider" then Sliders.paint(record, true)
		elseif record.Kind == "Dropdown" or record.Kind == "MultiDropdown" or record.Kind == "Keybind" then Controls.fieldAccent(record) end
	end
	for _, node in app._minis.Order do if node.GearImage then node.GearImage.ImageColor3 = Colors.accent(app) end end
	for _, record in app._buttons.ByPath do Controls.paintButton(record) end
	local popup = app._interaction.Popup
	if popup then Controls.paintPopup(popup) end
	Configs.paint(app)
end
function Colors.validate(value: Color3): ()
	assert(typeof(value)=="Color3","ColorPicker Default/Set require Color3")
	for _,channel in {value.R,value.G,value.B} do assert(channel==channel and channel>=0 and channel<=1,"ColorPicker channels must be finite within 0..1") end
end
function Colors.close(app: App): ()
	local popup=app._interaction.Color
	if not popup then return end
	app._interaction.Color=nil
	if app._interaction.Surface and app._interaction.Surface.Color==popup.Record then app._interaction.Surface=nil end
	local focused=app._env.Input:GetFocusedTextBox()
	local ownedFocus = focused and focused:IsDescendantOf(popup.Root)
	Resources.close(popup.Scope)
	if focused and ownedFocus then safe(function() focused:ReleaseFocus(false) end) end
end
function Colors.refresh(popup: ColorPopup): ()
	if popup.Scope.Closed then return end
	local record,value=popup.Record,popup.Record.Model.Value
	local channels={math.round(value.R*255),math.round(value.G*255),math.round(value.B*255)}
	popup.SV.BackgroundColor3=Color3.fromHSV(record.Hue,1,1)
	popup.Cursor.Position=UDim2.fromScale(record.Saturation,1-record.Brightness)
	popup.HueCursor.Position=UDim2.fromScale(0.5,record.Hue)
	popup.Preview.BackgroundColor3=value
	popup.Hex.Text=string.format("#%02X%02X%02X",channels[1],channels[2],channels[3])
	for index,channel in channels do popup.RGB[index].Text=tostring(channel) end
end
function Colors.paint(record: ColorRecord): ()
	if record.Gui.Field then record.Gui.Field.BackgroundColor3=record.Model.Value;Motion.alpha(record.Owner,record.Gui.Field,"BackgroundTransparency",0) end
	local popup=record.Owner._interaction.Color
	if popup and popup.Record==record then Colors.refresh(popup) end
end
function ColorPicker.Get(self: ColorPickerInternal): Color3 return self._record.Model.Value end
function ColorPicker.GetMetadata(self: ColorPickerInternal): ControlMetadata return self._record.Metadata end
function ColorPicker.GetButton(self: ColorPickerInternal): TextButton? return self._record.Gui.Field end
function ColorPicker.IsDestroyed(self: ColorPickerInternal): boolean return self._record.Scope.Closed end
function ColorPicker.Destroy(self: ColorPickerInternal) if not self._record.Scope.Closed then Controls.remove(self._record) end end
function Colors.set(record: ColorRecord,value: Color3,options: ValueSetOptions?,fromPointer: boolean?): ()
	Colors.validate(value);Controls.options(options)
	if record.Scope.Closed then return end
	if not fromPointer and record.Model.Value==value and not (options and options.Replay) then return end
	if not fromPointer then
		local h,s,v=value:ToHSV()
		if s>0 then record.Hue=h end
		if v>0 then record.Saturation=s end
		record.Brightness=v
	end
	local changed=record.Model.Value~=value
	record.Model.Value=value;Colors.paint(record)
	if record.Owner._background.Accent == record then Background.paint(record.Owner) end
	if record.Owner._preferences.Accent == record then
		record.Owner._preferences.AccentColor = value
		Colors.paintAccent(record.Owner)
	end
	if changed or (options and options.Replay) then Controls.emit(record,value,options) end
end
function ColorPicker.Set(self: ColorPickerInternal,value: Color3,options: ValueSetOptions?): ()
	Colors.set(self._record,value,options)
end
function Colors.place(popup: ColorPopup): ()
	if popup.Scope.Closed then return end
	local record,app=popup.Record,popup.Record.Owner
	local overlay,field=app._view.Overlay,record.Gui.Field
	if not overlay or not field or not Floating.anchorVisible(record,field) then Colors.close(app);return end
	local bounds=overlay.AbsoluteSize
	local size=Vector2.new(math.min(PickerStyle.Width,math.max(1,bounds.X-8)),math.min(PickerStyle.Height,math.max(1,bounds.Y-8)))
	popup.Root.Size=UDim2.fromOffset(size.X,size.Y)
	local position=popup.ManualPosition
	if not position then
		local at=field.AbsolutePosition-overlay.AbsolutePosition
		local y=at.Y+field.AbsoluteSize.Y+Appearance.PopupInset
		if y+size.Y>bounds.Y-Appearance.PopupInset then y=at.Y-size.Y-Appearance.PopupInset end
		position=Vector2.new(at.X+field.AbsoluteSize.X-size.X,y)
	end
	local bounded=Floating.clamp(app,position :: Vector2,size,Appearance.PopupInset)
	if popup.ManualPosition then popup.ManualPosition=bounded end
	popup.Root.Position=UDim2.fromOffset(bounded.X,bounded.Y)
end
function Colors.pointer(popup: ColorPopup,at: Vector2,isHue: boolean): ()
	local target=if isHue then popup.Hue else popup.SV
	local size,position=target.AbsoluteSize,target.AbsolutePosition
	if size.X<=0 or size.Y<=0 then return end
	local y=math.clamp((at.Y-position.Y)/size.Y,0,1)
	local record=popup.Record
	if isHue then record.Hue=y else record.Saturation=math.clamp((at.X-position.X)/size.X,0,1);record.Brightness=1-y end
	Colors.set(record,Color3.fromHSV(record.Hue,record.Saturation,record.Brightness),nil,true)
end
function Colors.open(record: ColorRecord): ()
	local app=record.Owner
	if not Controls.interactive(record) or not record.Gui.Field or not Floating.anchorVisible(record,record.Gui.Field) then return end
	if app._interaction.Color and app._interaction.Color.Record==record then Colors.close(app);return end
	Controls.cancel(app)
	local owned=scope()
	local created,root=protected(function()
		return create(app,"Frame","ColorPickerPopup",app._view.Overlay,Layers.Popup,{
		Size=UDim2.fromOffset(PickerStyle.Width,PickerStyle.Height),BackgroundColor3=Appearance.Card,
		BackgroundTransparency=0.08,ClipsDescendants=true,Active=true,
	},owned) :: Frame
	end)
	if not created then Resources.close(owned);diagnostic("color popup allocation: "..tostring(root));return end
	-- Publish the scope before subsequent allocations; every failure rolls back.
	local popup: ColorPopup={Scope=owned,Record=record,Root=root,RGB={}} :: ColorPopup
	app._interaction.Color=popup
	local ok,problem=protected(function()
		corner(app,root,6,owned)
		local function pickerSurface(name: string,x: number,y: number,width: number,height: number): Frame
			local object=create(app,"Frame",name,root,Layers.Popup,{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(width,height),BackgroundTransparency=0},owned)
			corner(app,object,4,owned);return object
		end
		popup.DragHandle=create(app,"TextButton","DragHandle",root,Layers.Popup,{
			AnchorPoint=Vector2.new(0.5,0),Position=UDim2.fromScale(0.5,0),Size=UDim2.fromOffset(40,PickerStyle.DragHeight),
			Text="",BackgroundTransparency=1,AutoButtonColor=false,Selectable=false,
		},owned)
		local line=create(app,"Frame","DragLine",popup.DragHandle,Layers.Popup,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),
			Size=UDim2.fromOffset(28,2),BackgroundColor3=Appearance.MutedText,BackgroundTransparency=0.45},owned);corner(app,line,1,owned)
		local top=PickerStyle.DragHeight+PickerStyle.Padding
		popup.SV=pickerSurface("SaturationValue",6,top,104,104)
		local white=create(app,"Frame","Saturation",popup.SV,Layers.Popup,{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1)},owned)
		corner(app,white,4,owned);create(app,"UIGradient","Gradient",white,nil,{Transparency=NumberSequence.new(0,1)},owned)
		local black=create(app,"Frame","Value",popup.SV,Layers.Popup,{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new()},owned)
		corner(app,black,4,owned);create(app,"UIGradient","Gradient",black,nil,{Rotation=90,Transparency=NumberSequence.new(1,0)},owned)
		popup.Hue=pickerSurface("Hue",114,top,12,104)
		popup.Hue.BackgroundColor3=Color3.new(1,1,1)
		local stops: {ColorSequenceKeypoint}={}
		for index=0,6 do table.insert(stops,ColorSequenceKeypoint.new(index/6,Color3.fromHSV(index/6,1,1))) end
		create(app,"UIGradient","Gradient",popup.Hue,nil,{Color=ColorSequence.new(stops),Rotation=90},owned)
		local function marker(parent: Frame,name: string,size: Vector2): Frame
			local object=create(app,"Frame",name,parent,Layers.Popup,{AnchorPoint=Vector2.new(0.5,0.5),
				Size=UDim2.fromOffset(size.X,size.Y),BackgroundColor3=Color3.new(1,1,1)},owned)
			corner(app,object,4,owned);create(app,"UIStroke","Outline",object,nil,{Thickness=1,Color=Color3.new()},owned);return object
		end
		popup.Cursor=marker(popup.SV,"Cursor",Vector2.new(6,6))
		popup.HueCursor=marker(popup.Hue,"Cursor",Vector2.new(16,3))
		popup.Preview=pickerSurface("Preview",6,130,20,18)
		local function textbox(name: string,x: number,y: number,width: number): TextBox
			local box=create(app,"TextBox",name,root,Layers.Popup,{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(width,18),
				BackgroundColor3=Appearance.Background,TextColor3=Appearance.Value,ClearTextOnFocus=false,Text="",
				FontFace=CONTROL_FACE,TextSize=11},owned);corner(app,box,4,owned);return box
		end
		popup.Hex=textbox("HEX",30,130,96)
		for index,name in {"R","G","B"} do
			local x=6+(index-1)*(112/3+4)
			popup.RGB[index]=textbox(name,x,164,112/3)
			create(app,"TextLabel",name.."Label",root,Layers.Popup,{Position=UDim2.fromOffset(x,150),Size=UDim2.fromOffset(112/3,12),
				Text=name,FontFace=CONTROL_FACE,TextSize=11,TextColor3=Appearance.MutedText,BackgroundTransparency=1},owned)
		end
		Resources.connect(owned,popup.Hex.FocusLost,function()
			if not Controls.interactive(record) then return end
			local digits=popup.Hex.Text:match("^#(%x%x%x%x%x%x)$")
			if digits then (record.Handle :: ColorPickerHandle):Set(Color3.fromRGB(tonumber(digits:sub(1,2),16) :: number,tonumber(digits:sub(3,4),16) :: number,tonumber(digits:sub(5,6),16) :: number)) end
			Colors.refresh(popup)
		end)
		for index,box in popup.RGB do Resources.connect(owned,box.FocusLost,function()
			if not Controls.interactive(record) then return end
			local number=if box.Text:match("^%d+$") then tonumber(box.Text) else nil
			if number and number>=0 and number<=255 then
				local value=record.Model.Value
				local channels={math.round(value.R*255),math.round(value.G*255),math.round(value.B*255)}
				channels[index]=number;(record.Handle :: ColorPickerHandle):Set(Color3.fromRGB(channels[1],channels[2],channels[3]))
			end
			Colors.refresh(popup)
		end) end
		local function start(target: GuiObject,kind: "SV" | "Hue" | "ColorDrag",event: InputObject)
			if not Controls.interactive(record) or not Floating.pointer(event) then return end
			Controls.cancelAssignment(app)
			app._interaction.Surface={Kind=kind,Color=record,Pointer=event,Origin=Vector2.new(event.Position.X,event.Position.Y),
				Position=Vector2.new(root.Position.X.Offset,root.Position.Y.Offset)}
			if kind~="ColorDrag" then Colors.pointer(popup,Vector2.new(event.Position.X,event.Position.Y),kind=="Hue") end
		end
		local surfaces: { { Target: Frame, Kind: "SV" | "Hue" } } = { {Target=popup.SV,Kind="SV"}, {Target=popup.Hue,Kind="Hue"} }
		for _, surface in surfaces do
			local hit=create(app,"TextButton","Hit",surface.Target,Layers.Popup,{Size=UDim2.fromScale(1,1),Text="",BackgroundTransparency=1,AutoButtonColor=false,Selectable=false},owned)
			Resources.connect(owned,hit.InputBegan,function(event) start(surface.Target,surface.Kind,event) end)
		end
		Resources.connect(owned,popup.DragHandle.InputBegan,function(event) start(popup.DragHandle,"ColorDrag",event) end)
		Resources.connect(owned,root.Destroying,function() Colors.close(app) end)
		Resources.connect(owned,(record.Gui.Field :: TextButton):GetPropertyChangedSignal("AbsolutePosition"),function() Colors.place(popup) end)
		Resources.connect(owned,(app._view.Overlay :: Frame):GetPropertyChangedSignal("AbsoluteSize"),function() Colors.place(popup) end)
		local rootSection = if record.Section.Kind == "MiniSection" then record.Section.RootSection else record.Section
		Resources.connect(owned,(Sections.container(app, rootSection.Tab) :: ScrollingFrame):GetPropertyChangedSignal("CanvasPosition"),function() Colors.close(app) end)
		if record.Section.Kind=="MiniSection" and record.Section.Scroll then Resources.connect(owned,record.Section.Scroll:GetPropertyChangedSignal("CanvasPosition"),function() Colors.close(app) end) end
		Colors.refresh(popup);Colors.place(popup)
	end)
	if not ok then Colors.close(app);diagnostic("color popup: "..tostring(problem)) end
end
function Section.AddColorPicker(self: SectionInternal | MiniInternal,options: ColorPickerOptions): ColorPickerHandle
	local host,app=self._record,self._record.Owner
	local metadata=Controls.metadata(host,options)
	Colors.validate(options.Default)
	assert(options.Callback==nil or type(options.Callback)=="function","ColorPicker Callback requires function")
	local h,s,v=options.Default:ToHSV()
	local record: ColorRecord={Kind="ColorPicker", Gui={},Metadata=metadata,Model={Kind="ColorPicker",Metadata=metadata,Default=options.Default,Value=options.Default},Hue=h,Saturation=s,Brightness=v,
		Scope=scope(),Owner=app,Section=host,Callback=options.Callback}
	local handle = Controls.mount(record, ColorPicker, function(order)
		Controls.field(record,order,PickerStyle.SwatchSize,PickerStyle.SwatchSize)
		Colors.paint(record)
		Resources.connect(record.Scope,(record.Gui.Field :: TextButton).Activated,function() Colors.open(record) end)
	end)
	return handle
end

-- One numeric path for Set, pointer and text confirmation; editor owns only a draft.
function Sliders.isFinite(value: unknown): boolean
	return finite(value)
end
function Sliders.decimals(value: number): number
	local text=string.format("%.15g",value)
	local mantissa,exponent=text:match("^([^eE]+)[eE]([%+%-]?%d+)$")
	local digits: string=mantissa or text
	local fraction=digits:match("%.(%d+)") or ""
	return math.max(0,#fraction-(tonumber(exponent) or 0))
end
function Sliders.normalize(record: SliderRecord,value: number): number
	assert(Sliders.isFinite(value),"Slider value must be finite")
	local clamped=math.clamp(value,record.Model.Minimum,record.Model.Maximum)
	local normalized=math.clamp(record.Model.Minimum+math.round((clamped-record.Model.Minimum)/record.Model.Step)*record.Model.Step,record.Model.Minimum,record.Model.Maximum)
	-- The range endpoint remains reachable if Max is not an exact step multiple.
	if clamped==record.Model.Maximum then normalized=record.Model.Maximum end
	if record.Model.Precision<=15 then normalized=tonumber(string.format("%."..record.Model.Precision.."f",normalized)) :: number end
	return math.clamp(normalized,record.Model.Minimum,record.Model.Maximum)
end
function Sliders.format(record: SliderRecord): string
	if record.Model.Value==0 then return "0" end
	local text
	if record.Model.Precision<=15 and math.abs(record.Model.Value)<1e16 then
		text=string.format("%."..record.Model.Precision.."f",record.Model.Value)
		if text:find(".",1,true) then text=text:gsub("0+$",""):gsub("%.$","") end
	else text=string.format("%.15g",record.Model.Value) end
	return text
end
function Sliders.sizeField(record: SliderRecord): ()
	local field,label=record.Gui.Field,record.Gui.Label
	if record.Scope.Closed or not field or not label then return end
	local width=math.clamp(math.ceil(field.TextBounds.X)+12,SliderStyle.MinimumField,SliderStyle.MaximumField)
	field.Size=UDim2.fromOffset(width,SliderStyle.Header)
	label.Size=UDim2.new(1,-width-10-Mini.gearSpace(record),0,SliderStyle.Header)
	Mini.placeGear(record)
end
function Sliders.paint(record: SliderRecord, instant: boolean?): ()
	if record.Scope.Closed then return end
	if record.Gui.Field and record.Owner._interaction.Editor~=record then record.Gui.Field.Text=Sliders.format(record) end
	local ratio=(record.Model.Value-record.Model.Minimum)/(record.Model.Maximum-record.Model.Minimum)
	local surface = record.Owner._interaction.Surface
	local immediate = instant or (surface ~= nil and surface.Slider == record)
	if record.Gui.Fill then Motion.to(record.Owner,record.Scope,record.Gui.Fill,{Size=UDim2.fromScale(ratio,1),BackgroundColor3=Colors.accent(record.Owner)},0.07,nil,immediate) end
	if record.Gui.Thumb then Motion.to(record.Owner,record.Scope,record.Gui.Thumb,{Position=UDim2.fromScale(ratio,0.5),BackgroundColor3=Colors.accent(record.Owner)},0.07,nil,immediate) end
	Sliders.sizeField(record)
end
function Slider.Get(self: SliderInternal): number return self._record.Model.Value end
function Slider.GetMetadata(self: SliderInternal): ControlMetadata return self._record.Metadata end
function Slider.GetButton(self: SliderInternal): TextBox? return self._record.Gui.Field end
function Slider.GetTrack(self: SliderInternal): Frame? return self._record.Gui.Track end
function Slider.IsDestroyed(self: SliderInternal): boolean return self._record.Scope.Closed end
function Slider.Set(self: SliderInternal,value: number,options: ValueSetOptions?): ()
	Controls.options(options)
	local record=self._record
	local normalized=Sliders.normalize(record,value)
	if record.Scope.Closed or (record.Model.Value==normalized and not (options and options.Replay)) then return end
	record.Model.Value=normalized;Sliders.paint(record)
	if record.Owner._background.Dimming == record then Background.paint(record.Owner) end
	Controls.emit(record,normalized,options)
end
function Sliders.finish(record: SliderRecord,commit: boolean): ()
	local app,field=record.Owner,record.Gui.Field
	if app._interaction.Editor~=record then return end
	app._interaction.Editor=nil
	if commit and field and Controls.interactive(record) then
		local value=tonumber(field.Text)
		if Sliders.isFinite(value) then (record.Handle :: SliderHandle):Set(value :: number) end
	end
	Sliders.paint(record)
	if field and app._env.Input:GetFocusedTextBox()==field then safe(function() field:ReleaseFocus(false) end) end
end
function Sliders.cancel(record: SliderRecord): ()
	if record.Owner._interaction.Surface and record.Owner._interaction.Surface.Slider==record then record.Owner._interaction.Surface=nil end
	Sliders.finish(record,false)
end
function Slider.Destroy(self: SliderInternal) if not self._record.Scope.Closed then Controls.remove(self._record) end end
function Sliders.pointer(record: SliderRecord,at: Vector2): ()
	local track=record.Gui.Track
	if not track or track.AbsoluteSize.X<=0 then return end
	local ratio=math.clamp((at.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
	local handle=record.Handle :: SliderHandle
	handle:Set(record.Model.Minimum+(record.Model.Maximum-record.Model.Minimum)*ratio)
end
function Sliders.begin(record: SliderRecord,event: InputObject): ()
	if not Controls.interactive(record) or not Floating.pointer(event) then return end
	local app=record.Owner
	Controls.cancel(app)
	app._interaction.Surface={Kind="Slider",Slider=record,Pointer=event,Origin=Vector2.new(event.Position.X,event.Position.Y),Position=Vector2.zero}
	Sliders.pointer(record,Vector2.new(event.Position.X,event.Position.Y))
end
function Section.AddSlider(self: SectionInternal | MiniInternal,options: SliderOptions): SliderHandle
	local host,app=self._record,self._record.Owner
	local metadata=Controls.metadata(host,options)
	assert(Sliders.isFinite(options.Min) and Sliders.isFinite(options.Max) and options.Max>options.Min,"Slider requires finite Min/Max and Max > Min")
	assert(Sliders.isFinite(options.Step) and options.Step>0,"Slider requires finite Step > 0")
	assert(Sliders.isFinite(options.Default),"Slider Default must be finite")
	assert(Sliders.isFinite(options.Max-options.Min) and Sliders.isFinite((options.Max-options.Min)/options.Step),"Slider span/step count exceeds numeric precision")
	assert(options.Callback==nil or type(options.Callback)=="function","Slider Callback requires function")
	local record: SliderRecord={Kind="Slider", Gui={},Metadata=metadata,Model={Kind="Slider",Metadata=metadata,Minimum=options.Min,Maximum=options.Max,Step=options.Step,
		Precision=math.max(Sliders.decimals(options.Min),Sliders.decimals(options.Max),Sliders.decimals(options.Step)),Default=options.Default,Value=options.Default},
		Scope=scope(),Owner=app,Section=host,Callback=options.Callback}
	record.Model.Value=Sliders.normalize(record,options.Default)
	record.Model.Default=record.Model.Value
	local handle = Controls.mount(record, Slider, function(order)
		local owned=record.Scope
		record.Gui.Row=create(app,"Frame","Slider_"..metadata.Id,host.Body,Layers.Content,{
			Size=UDim2.new(1,0,0,SliderStyle.Height),BackgroundTransparency=1,LayoutOrder=order,
		},owned)
		record.Gui.Label=create(app,"TextLabel","Label",record.Gui.Row,Layers.Content,{
			Position=UDim2.fromOffset(0,SliderStyle.HeaderY),Size=UDim2.new(1,-SliderStyle.MinimumField-10,0,SliderStyle.Header),BackgroundTransparency=1,
			Text=metadata.Name,TextSize=12,FontFace=CONTROL_FACE,TextColor3=Appearance.White,
			TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
		},owned)
		record.Gui.Field=create(app,"TextBox","Value",record.Gui.Row,Layers.Content,{
			AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,SliderStyle.HeaderY),Size=UDim2.fromOffset(SliderStyle.MinimumField,SliderStyle.Header),
			BackgroundColor3=Appearance.Field,BackgroundTransparency=0.2,Text=Sliders.format(record),TextColor3=Appearance.Value,
			FontFace=CONTROL_FACE,TextSize=11,ClearTextOnFocus=false,ClipsDescendants=true,TextXAlignment=Enum.TextXAlignment.Center,
		},owned);corner(app,record.Gui.Field :: TextBox,6,owned)
		create(app,"UIStroke","Outline",record.Gui.Field,nil,{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=1,Color=Appearance.FieldOutline,Transparency=0.45},owned)
		record.Gui.Track=create(app,"Frame","Track",record.Gui.Row,Layers.Content,{
			AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromOffset(0,SliderStyle.TrackY),Size=UDim2.new(1,0,0,SliderStyle.TrackHeight),
			BackgroundColor3=Appearance.FieldOutline,
		},owned);corner(app,record.Gui.Track :: Frame,2,owned)
		record.Gui.Fill=create(app,"Frame","Fill",record.Gui.Track,Layers.Content,{Size=UDim2.fromScale(0,1),BackgroundColor3=Appearance.IdleIcon},owned)
		corner(app,record.Gui.Fill :: Frame,2,owned)
		record.Gui.Thumb=create(app,"Frame","Thumb",record.Gui.Track,Layers.Content,{
			AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(SliderStyle.Thumb,SliderStyle.Thumb),BackgroundColor3=Appearance.White,
		},owned);corner(app,record.Gui.Thumb :: Frame,SliderStyle.Thumb/2,owned)
		record.Gui.Hit=create(app,"TextButton","Hit",record.Gui.Row,Layers.Content,{
			Position=UDim2.fromOffset(0,SliderStyle.TrackY-SliderStyle.HitHeight/2),Size=UDim2.new(1,0,0,SliderStyle.HitHeight),
			Text="",BackgroundTransparency=1,AutoButtonColor=false,Selectable=false,
		},owned)
		Resources.connect(owned,(record.Gui.Hit :: TextButton).InputBegan,function(event)Sliders.begin(record,event)end)
		Resources.connect(owned,(record.Gui.Field :: TextBox).Focused,function()
			if not Controls.interactive(record) then return end
			Controls.cancel(app);app._interaction.Editor=record
		end)
		Resources.connect(owned,(record.Gui.Field :: TextBox).FocusLost,function(_,event)
			if app._interaction.Editor==record then Sliders.finish(record,not event or event.KeyCode~=Enum.KeyCode.Escape) else Sliders.paint(record) end
		end)
		Resources.connect(owned,(record.Gui.Field :: TextBox):GetPropertyChangedSignal("TextBounds"),function()Sliders.sizeField(record)end)
		local objects: { Instance } = {record.Gui.Row :: Frame,record.Gui.Field :: TextBox,record.Gui.Hit :: TextButton}
		for _,object in objects do Resources.connect(owned,object.Destroying,function()if not owned.Closed then (record.Handle :: SliderHandle):Destroy()end end)end
		Resources.connect(owned,(record.Gui.Row :: Frame).AncestryChanged,function()if record.Gui.Row and record.Gui.Row.Parent~=host.Body then Sliders.cancel(record)end end)
		Resources.connect(owned,(record.Gui.Row :: Frame):GetPropertyChangedSignal("Visible"),function()if not Controls.interactive(record)then Sliders.cancel(record)end end)
		Sliders.paint(record)
	end)
	return handle
end

-- Static delegation shares the same builders and typed owner records.
MiniSection.AddToggle=Section.AddToggle
MiniSection.GetToggle=Section.GetToggle
MiniSection.AddDropdown=Section.AddDropdown
MiniSection.AddMultiDropdown=Section.AddMultiDropdown
MiniSection.AddKeybind=Section.AddKeybind
MiniSection.AddButton=Section.AddButton
MiniSection.AddColorPicker=Section.AddColorPicker
MiniSection.AddSlider=Section.AddSlider
function Toggle.CreateMiniSection(self: ToggleInternal): MiniHandle return Mini.create(self._record) end
function Dropdown.CreateMiniSection(self: DropdownInternal): MiniHandle return Mini.create(self._record) end
function MultiDropdown.CreateMiniSection(self: MultiDropdownInternal): MiniHandle return Mini.create(self._record) end
function Keybind.CreateMiniSection(self: KeybindInternal): MiniHandle return Mini.create(self._record) end
function Button.CreateMiniSection(self: ButtonInternal): MiniHandle return Mini.create(self._record) end
function Slider.CreateMiniSection(self: SliderInternal): MiniHandle return Mini.create(self._record) end
function ColorPicker.CreateMiniSection(self: ColorPickerInternal): MiniHandle return Mini.create(self._record) end

-- One executor bridge survives UI reloads, with no GUI/app retained while idle.
-- Game camera code sees its own requested input state; the physical cursor is
-- free until the lease ends. CameraType/CFrame/Focus and AutoRotate are untouched.
function Cursor.bridge(app: App): any
	local globals, base = app._env.Globals, getfenv(0)
	local bridge = globals[CURSOR_SLOT]
	if bridge then return bridge end
	local hook, closure, caller = globals.hookmetamethod or base.hookmetamethod, globals.newcclosure or base.newcclosure, globals.checkcaller or base.checkcaller
	local raw, restore = globals.getrawmetatable or base.getrawmetatable, globals.restorefunction or base.restorefunction
	local hooked = globals.isfunctionhooked or base.isfunctionhooked
	if type(hook) ~= "function" or type(closure) ~= "function" or type(caller) ~= "function"
		or type(raw) ~= "function" or type(restore) ~= "function" or type(hooked) ~= "function" then return nil end
	local meta = raw(game)
	assert(meta and type(meta.__index) == "function" and type(meta.__newindex) == "function", "Cursor metamethod contract changed")
	bridge = { Input = app._env.Input, Owner = nil, Targets = {}, Reads = 0, Writes = 0 }
	local writeTarget, readTarget = meta.__newindex, meta.__index
	local writeHooked, readHooked = hooked(writeTarget), hooked(readTarget)
	bridge.Restore = function()
		if bridge.Owner then return end
		local failures = {}
		for index = #bridge.Targets, 1, -1 do
			local entry = bridge.Targets[index]
			-- Two-argument restore preserves a preexisting detour; on a native
			-- target it would leave an unnecessary passthrough hook registered.
			local ok, problem = protected(function()
				if entry.WasHooked then restore(entry.Original, entry.Target) else restore(entry.Target) end
				return true
			end)
			if ok then table.remove(bridge.Targets, index) else table.insert(failures, tostring(problem)) end
		end
		if #failures > 0 then error("Cursor hook restore: " .. table.concat(failures, "; "), 0) end
		if globals[CURSOR_SLOT] == bridge then globals[CURSOR_SLOT] = nil end
	end
	local previousWrite: any
	previousWrite = hook(game, "__newindex", closure(function(object: any, key: any, value: any)
		if object == bridge.Input then bridge.Writes += 1 end
		local owner = bridge.Owner
		if object == bridge.Input and owner and owner.Active and not owner.Writing then
			if key == "MouseBehavior" and typeof(value) == "EnumItem" and value.EnumType == Enum.MouseBehavior then
				owner.Mouse, value = value, Enum.MouseBehavior.Default
			elseif key == "MouseIconEnabled" and type(value) == "boolean" then owner.Icon, value = value, true
			elseif key == "MouseDeltaSensitivity" and finite(value) then owner.Sensitivity, value = value, 0 end
		end
		return previousWrite(object, key, value)
	end))
	table.insert(bridge.Targets, { Target = writeTarget, Original = previousWrite, WasHooked = writeHooked })
	-- Publish partial ownership so a failed second hook is still reversible.
	globals[CURSOR_SLOT] = bridge
	local previousRead: any
	previousRead = hook(game, "__index", closure(function(object: any, key: any)
		if object == bridge.Input then bridge.Reads += 1 end
		local owner = bridge.Owner
		if object == bridge.Input and owner and owner.Active and not caller() then
			if key == "MouseBehavior" then return owner.Mouse
			elseif key == "MouseIconEnabled" then return owner.Icon
			elseif key == "MouseDeltaSensitivity" then return owner.Sensitivity end
		end
		return previousRead(object, key)
	end))
	table.insert(bridge.Targets, { Target = readTarget, Original = previousRead, WasHooked = readHooked })
	return bridge
end
function Cursor.maintain(app: App): ()
	local capture, input = app._capture, app._env.Input
	if not capture.Active or capture.Writing then return end
	capture.Writing = true
	local ok, problem = protected(function()
		if input.MouseBehavior ~= Enum.MouseBehavior.Default then input.MouseBehavior = Enum.MouseBehavior.Default end
		if not input.MouseIconEnabled then input.MouseIconEnabled = true end
		if input.MouseDeltaSensitivity ~= 0 then input.MouseDeltaSensitivity = 0 end
	end)
	capture.Writing = false
	if not ok then error(problem, 0) end
end
function Cursor.release(app: App): ()
	local capture = app._capture
	if not capture.Active and not capture.Scope then return end
	capture.Active = false
	if capture.Bridge and capture.Bridge.Owner == capture then capture.Bridge.Owner = nil end
	capture.Bridge = nil
	local owned = capture.Scope
	capture.Scope = nil
	if owned then Resources.close(owned) end
	local focused = app._env.Input:GetFocusedTextBox()
	if focused and app.ScreenGui and focused:IsDescendantOf(app.ScreenGui) then safe(function() focused:ReleaseFocus(false) end) end
	local mouse, icon, sensitivity = capture.Mouse, capture.Icon, capture.Sensitivity
	capture.Mouse, capture.Icon, capture.Sensitivity = nil, nil, nil
	if sensitivity ~= nil then safe(function() app._env.Input.MouseDeltaSensitivity = sensitivity end) end
	if mouse then safe(function() app._env.Input.MouseBehavior = mouse end) end
	if icon ~= nil then safe(function() app._env.Input.MouseIconEnabled = icon end) end
end
function Cursor.acquire(app: App): ()
	local capture, env = app._capture, app._env
	if capture.Active then return end
	local owned = scope()
	capture.Scope = owned
	capture.Mouse, capture.Icon = env.Input.MouseBehavior, env.Input.MouseIconEnabled
	capture.Sensitivity = env.Input.MouseDeltaSensitivity
	capture.Bridge = Cursor.bridge(app)
	capture.Active = true
	if capture.Bridge then capture.Bridge.Owner = capture end
	create(app, "TextButton", "CursorModal", app._view.Canvas, Layers.Background, {
		Size = UDim2.fromOffset(1, 1), BackgroundTransparency = 1, Text = "", Modal = true,
		Active = false, AutoButtonColor = false, Selectable = false,
	}, owned)
	-- Register release rights before calling APIs which may throw midway through.
	Resources.add(owned, function() env.Actions:UnbindAction(capture.Action) end)
	env.Actions:BindActionAtPriority(capture.Action, function() return Enum.ContextActionResult.Sink end,
		false, Enum.ContextActionPriority.High.Value + 100,
		Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseWheel)
	local function maintain()
		if capture.Active then
			local ok, problem = protected(Cursor.maintain, app)
			if not ok then app:_fail("cursor capture: " .. tostring(problem)) end
		end
	end
	Resources.add(owned, function() env.Run:UnbindFromRenderStep(capture.RenderAfter) end)
	env.Run:BindToRenderStep(capture.RenderAfter, Enum.RenderPriority.Last.Value + 1, maintain)
	for _, property in { "MouseBehavior", "MouseIconEnabled", "MouseDeltaSensitivity" } do
		Resources.connect(owned, env.Input:GetPropertyChangedSignal(property), function()
			if not capture.Active or capture.Writing then return end
			if not capture.Bridge then
				if property == "MouseBehavior" and env.Input.MouseBehavior ~= Enum.MouseBehavior.Default then capture.Mouse = env.Input.MouseBehavior
				elseif property == "MouseIconEnabled" and not env.Input.MouseIconEnabled then capture.Icon = false
				elseif property == "MouseDeltaSensitivity" and env.Input.MouseDeltaSensitivity ~= 0 then capture.Sensitivity = env.Input.MouseDeltaSensitivity end
			end
			maintain()
		end)
	end
	Cursor.maintain(app)
end

-- Input owns only listeners and one pointer gesture; RightShift is readiness gated.
local function point(event: InputObject): Vector2
	return Vector2.new(event.Position.X, event.Position.Y)
end
function Input.resizeVisual(app: App): ()
	local clip, line = app._view.ResizeVisual, app._view.ResizeStroke
	if not clip or not line then return end
	local pressed = app._input.Gesture ~= nil and (app._input.Gesture :: Gesture).Kind == "resize"
	local hovered = app._input.ResizeHovered and Gui.showing(app)
	local brightness = if pressed then 1 elseif hovered then 0.75 else 0.5
	local tint = Color3.new(brightness, brightness, brightness)
	Motion.to(app, app._input.Scope, line, { Color = tint }, 0.10)
	local caps: { Frame } = app._view.ResizeCaps or {}
	for _, cap in caps do Motion.to(app, app._input.Scope, cap, { BackgroundColor3 = tint }, 0.10) end
end
function Input.finish(app: App): ()
	app._interaction.Surface = nil
	Mini.closeBranch(app, 1)
	app._input.Gesture = nil
	if not Gui.showing(app) then app._input.ResizeHovered = false end
	Input.resizeVisual(app)
	app._interaction.ConsumedPointer = nil
	Controls.cancel(app)
	Sections.cancelDrag(app)
end
function Input.begin(app: App, event: InputObject, kind: string): ()
	if not Gui.showing(app) or app._motion.Menu or app._input.Gesture or app._sections.Drag then return end
	if event.UserInputType ~= Enum.UserInputType.MouseButton1 and event.UserInputType ~= Enum.UserInputType.Touch then return end
	if app._interaction.Surface or Floating.hit(app, point(event)) or app._interaction.Assignment or app._interaction.ConsumedPointer == event then return end
	if kind == "drag" then
		if app._view.TabStrip and Controls.contains(app._view.TabStrip, point(event)) then return end
		for _, record in app._tabs.Order do
			if record.Button and Controls.contains(record.Button, point(event)) then return end
		end
	end
	Motion.cancel(app); Mini.closeBranch(app, 1)
	Controls.cancel(app)
	app._input.Gesture = {
		Kind = kind, Pointer = event, Origin = point(event),
		Position = app._geometry.Position, Size = app._geometry.Size,
	}
	Input.resizeVisual(app)
end
function Input.connect(app: App): ()
	local owned, env, view = app._input.Scope, app._env, app._view
	Resources.connect(owned, (view.Panel :: Frame).InputBegan, function(event) Input.begin(app, event, "drag") end)
	Resources.connect(owned, (view.Grip :: TextButton).InputBegan, function(event) Input.begin(app, event, "resize") end)
	Resources.connect(owned, env.Input.InputBegan, function(event)
		if not app.ScreenGui or not app.ScreenGui.Enabled then return end
		if view.SearchInput and env.Input:GetFocusedTextBox() == view.SearchInput and app._life.Visible and event.UserInputType == Enum.UserInputType.Keyboard then
			if event.KeyCode == Enum.KeyCode.Return or event.KeyCode == Enum.KeyCode.KeypadEnter then Modes.finishSearch(app)
			elseif event.KeyCode == Enum.KeyCode.Escape then
				if view.SearchInput.Text ~= "" then view.SearchInput.Text = ""; Modes.query(app, "") else Modes.search(app, false) end
			end
			return
		end
		if Controls.input(app, event) then return end
		if event.KeyCode == Enum.KeyCode.Escape and app._sections.Drag then Sections.cancelDrag(app); return end
		if event.KeyCode == Enum.KeyCode.Escape and app._life.Visible and not Modes.settingsOpen(app) and app._tabs.Search and app._tabs.Search.Active then Modes.search(app, false); return end
		local key = app:GetMenuKeybind()
		local pressed = key ~= nil and (if key.EnumType == Enum.KeyCode then event.UserInputType == Enum.UserInputType.Keyboard and event.KeyCode == key else event.UserInputType == key)
		if app._life.Phase == "ready" and pressed and not app._interaction.Editor and not env.Input:GetFocusedTextBox() then
			app:SetVisible(not app._life.Visible)
		end
	end)
	Resources.connect(owned, env.Input.InputChanged, function(event)
		if app._interaction.Surface then Floating.move(app, event); return end
		local strip = view.TabStrip
		if event.UserInputType == Enum.UserInputType.MouseWheel and strip and strip.ScrollingEnabled
			and app._life.Phase == "ready" and app._life.Visible and not app._input.Gesture and not app._sections.Drag then
			-- The strip consumes wheel only over its own clipped viewport.
			-- GetMouseLocation includes GuiInset; GuiObject.AbsolutePosition does not.
			local at = env.Input:GetMouseLocation() - game:GetService("GuiService"):GetGuiInset()
			if Controls.contains(strip, at) and not Floating.hit(app, at) then
				local limit = math.max(0, strip.CanvasSize.X.Offset - strip.AbsoluteWindowSize.X)
				strip.CanvasPosition = Vector2.new(math.clamp(strip.CanvasPosition.X - event.Position.Z * 40, 0, limit), 0)
			end
		end
		local sectionDrag = app._sections.Drag
		if sectionDrag then
			local mouse = sectionDrag.Pointer.UserInputType == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseMovement
			if mouse or event == sectionDrag.Pointer then Sections.moveDrag(app, point(event)) end
			return
		end
		local gesture = app._input.Gesture
		if not gesture or not app._life.Visible then return end
		local mouse = gesture.Pointer.UserInputType == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseMovement
		if not mouse and event ~= gesture.Pointer then return end
		local delta = point(event) - gesture.Origin
		if gesture.Kind == "drag" then app._geometry.Position = gesture.Position + delta
		else
			local geometry = app._geometry
			local margin = Layout.margin(geometry.Viewport)
			local limit = geometry.Viewport - geometry.Position - Vector2.new(margin, margin)
			local desired = gesture.Size + delta
			geometry.Size = Vector2.new(math.min(desired.X, limit.X), math.min(desired.Y, limit.Y))
		end
		Layout.apply(app)
	end)
	Resources.connect(owned, env.Input.InputEnded, function(event)
		if app._interaction.Surface and Floating.matches(app._interaction.Surface.Pointer, event, true) then app._interaction.Surface = nil; return end
		if app._interaction.ConsumedPointer == event then
			-- Activated is delivered after release. Keep the assignment press
			-- consumed until that batch has finished, including other controls.
			Resources.spawn(owned, function() if app._interaction.ConsumedPointer == event then app._interaction.ConsumedPointer = nil end end)
		end
		local sectionDrag = app._sections.Drag
		if sectionDrag and (event == sectionDrag.Pointer or (sectionDrag.Pointer.UserInputType == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseButton1)) then
			Sections.moveDrag(app, sectionDrag.Point)
			Sections.endDrag(app, true)
			return
		end
		local gesture = app._input.Gesture
		if gesture and Floating.matches(gesture.Pointer, event, true) then Input.finish(app) end
	end)
	Resources.connect(owned, env.Input.WindowFocusReleased, function() Input.finish(app) end)
	local cameraScope: Scope? = nil
	Resources.add(owned, function() if cameraScope then Resources.close(cameraScope) end end)
	local function viewportChanged()
		Input.finish(app)
		Layout.apply(app)
	end
	local function bindCamera()
		if cameraScope then Resources.close(cameraScope) end
		cameraScope = scope()
		local camera = workspace.CurrentCamera
		if camera then Resources.connect(cameraScope :: Scope, camera:GetPropertyChangedSignal("ViewportSize"), viewportChanged) end
		viewportChanged()
	end
	Resources.connect(owned, workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
	Resources.connect(owned, (view.Canvas :: Frame):GetPropertyChangedSignal("AbsoluteSize"), viewportChanged)
	bindCamera()
end

-- Bootstrap counts completed work only. Deadlines are cancellation, not progress.
local Bootstrap: BootstrapComponent = {} :: any
function Bootstrap.complete(app: App, stage: string): ()
	if not alive(app) then return end
	app._life.Completed += 1
	app._life.Stage = stage
	if app._view.Progress then app._view.Progress.Size = UDim2.fromScale(app._life.Completed / 4, 1) end
end
function Bootstrap.icons(app: App): ()
	-- AddTab before readiness joins this finite bootstrap; ready additions own
	-- their bounded icon worker without reviving the main loading screen.
	repeat
		while alive(app) do
			local pending: TabRecord? = nil
			for _, record in app._tabs.Order do if record.Outcome == "pending" then pending = record; break end end
			if not pending then break end
			Tabs.load(app, pending)
		end
		if not alive(app) then return end
		Sections.loadHeaderIcons(app)
		if alive(app) then Controls.loadDropdownIcon(app) end
		if alive(app) then Controls.loadButtonIcon(app) end
		if alive(app) then Mini.loadIcon(app) end
		-- Those loaders yield. New tabs/sections/controls can join meanwhile.
		-- Seal readiness only after every newly admitted required icon is loaded.
		local outstanding = #app._sections.Order > 0 and not app._sections.HeaderIconsStarted
			or (#app._minis.Order > 0 and not app._icons.GearStarted)
		for _, record in app._buttons.ByPath do
			if record.IconOutcome == "pending" or record.IconOutcome == "loading" then outstanding = true end
		end
		for _, record in app._tabs.Order do if record.Outcome == "pending" then outstanding = true end end
		for _, collection in app._values.BySection do
			for _, record in collection.Order do
				if (record.Kind == "Dropdown" or record.Kind == "MultiDropdown") and not app._icons.DropdownStarted then outstanding = true end
			end
		end
		if outstanding then task.wait() end
	until not alive(app) or not outstanding
end
function Bootstrap.run(app: App): ()
	local ok, problem = xpcall(function(): ...any
		app._life.Stage = "environment"
		Runtime.prepare(app)
		if not alive(app) then return end
		Bootstrap.complete(app, "environment")
		app._life.Stage = "gui"
		Gui.build(app)
		Configs.build(app)
		while alive(app) and Layout.viewport(app).Magnitude == 0 do task.wait() end
		if not alive(app) then return end
		Layout.apply(app)
		Bootstrap.complete(app, "gui")
		-- Optional resources use the existing bounded jobs; readiness never waits
		-- for them and the original four-stage bootstrap deadline is unchanged.
		Background.start(app)
		app._life.Stage = "icons"
		Bootstrap.icons(app)
		if not alive(app) then return end
		Bootstrap.complete(app, "icons")
		app._life.Stage = "input"
		Input.connect(app)
		Bootstrap.complete(app, "input")
		if not alive(app) then return end
		-- Loader is gone before the main menu or its cursor lease can become visible.
		local loading = app._view.Loading
		app._view.Loading, app._view.Progress = nil, nil
		if loading then loading:Destroy() end
		app._life.Phase, app._life.Stage = "ready", "ready"
		app:SetVisible(app._life.RequestedVisible)
	end, debug.traceback)
	if not ok and alive(app) then app:_fail(tostring(problem)) end
	Resources.close(app._boot)
end

function Application.GetMenuKeybind(self: App): EnumItem?
	local binding = self._preferences.MenuBinding
	return if binding then binding.Model.Value else self._preferences.InitialKey
end
function Application.SetMenuKeybind(self: App, key: EnumItem?): ()
	assert(Controls.validKey(key), "Menu Keybind requires a keyboard key, mouse button, or nil")
	if not alive(self) then return end
	local value = key
	local binding = self._preferences.MenuBinding
	if binding and binding.Handle then binding.Handle:Set(value, { Emit = false }) else self._preferences.InitialKey = value end
end
function Application.GetAnimationsEnabled(self: App): boolean
	local record = self._preferences.Animations
	return if record then record.Model.Value else self._preferences.InitialAnimations
end
function Application.SetAnimationsEnabled(self: App, enabled: boolean): ()
	assert(type(enabled) == "boolean", "AnimationsEnabled requires boolean")
	if not alive(self) then return end
	local record = self._preferences.Animations
	if record and record.Handle then record.Handle:Set(enabled, { Emit = false })
	else self._preferences.InitialAnimations = enabled; Motion.policy(self) end
end
-- Rebuild operations outlive the old menu, but own their deadline and thread.
-- Weak keys also revoke a cancelled native continuation without retaining it.
local Reload = { Workers = setmetatable({} :: { [thread]: ReloadGate }, { __mode = "k" }) }
function Reload.cancel(gate: ReloadGate, globals: { [string]: any }): ()
	if not gate.Pending then return end
	gate.Pending, gate.Cancelled = false, true
	if globals[RELOAD_SLOT] == gate then globals[RELOAD_SLOT] = nil end
	local candidate = gate.Candidate
	if candidate then safe(function() candidate:Destroy() end) end
	Resources.close(gate.Scope)
end
function Reload.copy(value: any): any
	if type(value) ~= "table" or typeof(value) ~= "table" then return value end
	local result: { [any]: any } = {}
	for key, item in value do result[key] = Reload.copy(item) end
	return result
end
local function reloadSnapshot(app: App): ReloadState
	local result: ReloadState = {
		MenuKeybind = app:GetMenuKeybind(), AnimationsEnabled = app:GetAnimationsEnabled(), Visible = app:IsVisible(),
		Position = app._geometry.Position, Size = app._geometry.Size, Tabs = {}, Values = {}, Buttons = {}, CompletedButtons = {}, Sections = {}, Order = {},
		Reordered = app._sections.Reordered, Minis = {}, OpenMinis = {},
		ContentScroll = if app.ContentRoot then app.ContentRoot.CanvasPosition else Vector2.zero,
		SettingsScroll = if app._view.SettingsContent then app._view.SettingsContent.CanvasPosition else Vector2.zero,
		TabScroll = if app.TabStrip then app.TabStrip.CanvasPosition else Vector2.zero,
		Query = app._search.Query, SearchEditing = app._search.Editing, SearchCollapsed = table.clone(app._search.Collapsed),
		SearchSavedScroll = app._search.SavedScroll, SearchRestoreScroll = app._search.RestoreScroll,
	}
	for _, tab in app._tabs.Order do result.Tabs[tab.Metadata.Id] = tab.Active end
	for path, model in app._values.ByPath do
		result.Values[path] = { Kind = model.Kind, Value = if model.Kind == "MultiDropdown" then table.clone(model.Value) else model.Value,
			Values = if model.Kind == "Dropdown" or model.Kind == "MultiDropdown" then table.clone(model.Values) else nil }
	end
	for path, button in app._buttons.ByPath do
		result.Buttons[path] = button.Disabled
		if button.Completed then (result.CompletedButtons :: { [string]: boolean })[path] = true end
	end
	for _, section in app._sections.Order do
		result.Sections[section.Metadata.Path] = section.Collapsed
		table.insert(result.Order, section.Metadata.Path)
	end
	for path, mini in app._minis.ByControl do
		if mini.Root then result.Minis[path] = { Position = mini.Root.Position, Scroll = if mini.Scroll then mini.Scroll.CanvasPosition else Vector2.zero } end
	end
	for _, mini in app._minis.Chain do table.insert(result.OpenMinis, mini.OwnerControl.Metadata.Path) end
	return result
end
local function restoreReload(app: App, saved: ReloadState): ()
	-- Validate the owner's complete rebuild before mutating its values.
	local records: { [string]: { Kind: string, Handle: any } } = {}
	for _, collection in app._values.BySection do
		for _, record in collection.Order do records[record.Metadata.Path] = { Kind = record.Kind, Handle = record.Handle } end
	end
	local sections: { [string]: SectionRecord } = {}
	for _, section in app._sections.Order do sections[section.Metadata.Path] = section end
	for id in saved.Tabs do assert(app._tabs.ById[id], "OnReload omitted tab: " .. id) end
	for path, value in saved.Values do assert(records[path] and records[path].Kind == value.Kind, "OnReload omitted/changed control: " .. path) end
	for path in saved.Buttons do assert(app._buttons.ByPath[path], "OnReload omitted button: " .. path) end
	for path in saved.Sections do assert(sections[path], "OnReload omitted section: " .. path) end
	for path in saved.Minis do assert(app._minis.ByControl[path], "OnReload omitted mini-section: " .. path) end
	for path, value in saved.Values do
		local record = records[path]
		local handle: any = record.Handle
		if value.Values then handle:SetValues(table.clone(value.Values), { Emit = false }) end
		handle:Set(if value.Kind == "MultiDropdown" then table.clone(value.Value) else value.Value, { Emit = false })
	end
	for path, disabled in saved.Buttons do (app._buttons.ByPath[path].Handle :: ButtonHandle):SetDisabled(disabled) end
	if saved.CompletedButtons then
		for path, completed in saved.CompletedButtons do
			local button = app._buttons.ByPath[path]
			if button and not button.Repeatable then button.Completed = completed == true; Controls.paintButton(button) end
		end
	end
	for id, active in saved.Tabs do app._tabs.ById[id].Active = active; Tabs.paint(app._tabs.ById[id], true) end
	for path, collapsed in saved.Sections do sections[path].Collapsed = collapsed end
	local order: { SectionRecord } = {}
	for _, path in saved.Order do table.insert(order, sections[path]) end
	for _, section in app._sections.Order do if not table.find(order, section) then table.insert(order, section) end end
	app._sections.Order, app._sections.Reordered = order, saved.Reordered
	app._search.Query, app._search.Editing, app._search.Collapsed = saved.Query, saved.SearchEditing, table.clone(saved.SearchCollapsed)
	app._search.SavedScroll, app._search.RestoreScroll, app._search.Dirty = saved.SearchSavedScroll, saved.SearchRestoreScroll, true
	if app._view.SearchInput then app._view.SearchInput.Text = saved.Query end
	app:SetMenuKeybind(saved.MenuKeybind); app:SetAnimationsEnabled(saved.AnimationsEnabled)
	app:SetGeometry(saved.Position, saved.Size)
	Modes.refresh(app); Sections.reflow(app)
	if app.ContentRoot then app.ContentRoot.CanvasPosition = saved.ContentScroll end
	if app._view.SettingsContent then app._view.SettingsContent.CanvasPosition = saved.SettingsScroll end
	if app.TabStrip then app.TabStrip.CanvasPosition = saved.TabScroll end
	for path, view in saved.Minis do
		local node = app._minis.ByControl[path]
		if node.Root then node.Root.Position = view.Position end
		if node.Scroll then node.Scroll.CanvasPosition = view.Scroll end
	end
	app:SetVisible(saved.Visible)
	if saved.Visible then
		for _, path in saved.OpenMinis do
			local node = app._minis.ByControl[path]
			node.Open = true; table.insert(app._minis.Chain, node)
			if node.Root then node.Root.Visible = true end
			Mini.layout(node)
		end
	end
end
function Application.Reload(self: App): App?
	local hook = self._preferences.OnReload
	local globals = self._env.Globals
	if self._life.Phase ~= "ready" or not hook or self._preferences.Unloading or globals[RELOAD_SLOT] then return nil end
	local saved = reloadSnapshot(self)
	local gate: ReloadGate = { Scope = scope(), Thread = coroutine.running(), Pending = true, Cancelled = false, Deadline = os.clock() + self._life.Timeout }
	globals[RELOAD_SLOT] = gate
	local replacement: App? = nil
	local failure: string? = nil
	-- The UI owns the rebuild worker, never the caller's thread (which can be a
	-- loader, job or an unrelated gameplay owner waiting for a return value).
	local worker = Resources.spawn(gate.Scope, function()
		Reload.Workers[coroutine.running()] = gate
		local ok, problem = protected(function()
			self:Destroy()
			replacement = hook(Reload.copy(saved))
			assert(gate.Pending and not gate.Cancelled, "OnReload was cancelled")
			assert(type(replacement) == "table" and replacement ~= self and globals[INSTANCE_SLOT] == replacement, "OnReload must return a new defolt instance")
			local app = replacement :: App
			while gate.Pending and app._life.Phase == "loading" and os.clock() < math.min(app._life.Deadline, gate.Deadline) do task.wait() end
			assert(gate.Pending and globals[INSTANCE_SLOT] == app, "OnReload ownership was replaced")
			assert(app._life.Phase == "ready", app._life.Error or "OnReload build did not become ready")
			restoreReload(app, saved)
			app._preferences.Restoring = false
		end)
		Reload.Workers[coroutine.running()] = nil
		if not ok then failure = tostring(problem) end
		gate.Pending = false
		if globals[RELOAD_SLOT] == gate then globals[RELOAD_SLOT] = nil end
		Resources.close(gate.Scope)
		if not ok and gate.Candidate then safe(function() (gate.Candidate :: App):Destroy() end) end
	end)
	gate.Thread = worker :: thread
	Resources.spawn(gate.Scope, function()
		while gate.Pending and os.clock() < gate.Deadline do task.wait() end
		if gate.Pending then
			diagnostic("Reload Menu: owner rebuild deadline exceeded")
			Reload.cancel(gate, globals)
		end
	end)
	while gate.Pending and os.clock() < gate.Deadline do task.wait() end
	if gate.Pending then Reload.cancel(gate, globals) end
	if gate.Cancelled or failure then
		if failure then diagnostic("Reload Menu: " .. failure) end
		return nil
	end
	return replacement
end
function Application.Unload(self: App): ()
	if not alive(self) or self._preferences.Unloading then return end
	self._preferences.Unloading = true
	local hook = self._preferences.OnUnload
	self:Destroy()
	local ok, problem = true, nil
	if hook then ok, problem = protected(hook) end
	if not ok then diagnostic("Unload owner: " .. tostring(problem)) end
end

-- Public lifecycle is explicit; cleanup revokes admission before any callbacks.
function Application._dispose(self: App): ()
	self._preferences.InitialKey, self._preferences.InitialAnimations = self:GetMenuKeybind(), self:GetAnimationsEnabled()
	safe(function() Motion.cancel(self) end)
	self._life.Visible = false
	self._search.Editing = false
	safe(function() Modes.releaseSearch(self) end)
	safe(function() Input.finish(self) end)
	safe(function() Cursor.release(self) end)
	local bridge = self._env.Globals[CURSOR_SLOT]
	if bridge and not bridge.Owner and type(bridge.Restore) == "function" then safe(bridge.Restore) end
	safe(function() Resources.close(self._input.Scope) end)
	safe(function() Resources.close(self._boot) end)
	safe(function() Resources.close(self._scope) end)
	table.clear(self._view)
	self.ScreenGui, self.Root, self.ContentRoot, self.OverlayRoot = nil, nil, nil, nil
	self.Panel, self.TabStrip, self.ResizeHandle = nil, nil, nil
	self._env.Capabilities = {}
	self._configs.Capabilities = {}
	self._configs.Provider, self._configs.Transform, self._configs.Active, self._configs.Selected = nil, nil, nil, nil
	table.clear(self._tabs.Order); table.clear(self._tabs.ById)
	table.clear(self._sections.Order); table.clear(self._sections.ByTab)
	self._tabs.Search, self._tabs.Settings = nil, nil
	self._sections.Queued = false
	table.clear(self._search.Sections); table.clear(self._search.Controls); table.clear(self._search.Collapsed)
	self._search.Query, self._search.SavedScroll, self._search.RestoreScroll, self._search.Dirty = "", nil, nil, false
	self._search.SectionCount, self._search.ControlCount = 0, 0
	self._preferences.MenuBinding, self._preferences.Animations, self._preferences.OnReload, self._preferences.OnUnload = nil, nil, nil, nil
	self._preferences.Accent = nil
	if self._env.Globals[INSTANCE_SLOT] == self then self._env.Globals[INSTANCE_SLOT] = nil end
end
function Application._fail(self: App, problem: string): ()
	if not alive(self) then return end
	self._life.Phase, self._life.Error = "failed", problem
	diagnostic("startup/runtime failure at " .. self._life.Stage .. ": " .. problem)
	self:_dispose()
end
function Application.Destroy(self: App): ()
	if self._life.Phase == "destroyed" then return end
	self._life.Phase = "destroyed"
	self:_dispose()
end
function Application.IsDestroyed(self: App): boolean
	return self._life.Phase == "destroyed" or self._life.Phase == "failed"
end
function Application.SetVisible(self: App, visible: boolean): ()
	assert(type(visible) == "boolean", "SetVisible expects boolean")
	if not alive(self) then return end
	self._life.RequestedVisible = visible
	if self._life.Phase ~= "ready" then return end
	if self._life.Visible == visible then return end
	if not visible then
		Motion.cancel(self)
		self._life.Visible = false
		Background.visible(self)
		Modes.finishSearch(self)
		Input.finish(self)
		Cursor.release(self)
		Tabs.clearHover(self)
		if self._view.Grip then self._view.Grip.Visible = false end
		if self._view.Root then self._view.Root.Visible = false end
		if self._view.Overlay then self._view.Overlay.Visible = false end
		return
	end
	Layout.apply(self)
	local ok, problem = protected(Cursor.acquire, self)
	if not ok then self:_fail("cursor acquisition: " .. tostring(problem)); return end
	self._life.Visible = true
	if self._view.Grip then self._view.Grip.Visible = true end
	if self._view.Root then self._view.Root.Visible = true end
	if self._view.Overlay then self._view.Overlay.Visible = true end
	Background.visible(self)
	Modes.paint(self)
	Motion.intro(self)
	Modes.focus(self)
end
function Application.IsVisible(self: App): boolean return self._life.Visible end
function Application.SetGeometry(self: App, position: Vector2, size: Vector2): ()
	if not alive(self) then return end
	self._geometry.Position, self._geometry.Size = vector(position, Vector2.zero), vector(size, Appearance.Initial)
	self._geometry.Initialized = true
	Input.finish(self)
	Layout.apply(self)
end
function Application.GetGeometry(self: App): { Position: Vector2, Size: Vector2, Viewport: Vector2 }
	return { Position = self._geometry.Position, Size = self._geometry.Size, Viewport = self._geometry.Viewport }
end
function Application.GetIconStats(self: App): IconStats
	return table.clone(self._icons.Stats)
end
function Application.ListBackgrounds(self: App): { string }
	assert(alive(self), "Menu was destroyed"); return Background.list(self)
end
function Application.RefreshBackgrounds(self: App): { string }
	assert(alive(self), "Menu was destroyed"); return Background.refresh(self)
end
function Application.GetBackground(self: App): string? return self._background.File end
function Application.SetBackground(self: App, file: string?): ()
	assert(alive(self), "Menu was destroyed")
	if file then Background.path(file) end
	local record = self._background.Selection
	assert(record and not record.Scope.Closed, "Background controls were destroyed")
	local choice = file or "Default"
	if not table.find(record.Model.Values, choice) then
		local names = table.clone(record.Model.Values); table.insert(names, choice);
		(record.Handle :: DropdownHandle):SetValues(names, { Emit = false })
	end
	(record.Handle :: DropdownHandle):Set(choice)
end
function Application.GetBackgroundDim(self: App): number return self._background.Dim end
function Application.GetBackgroundColor(self: App): Color3 return self._background.Color end
function Application.GetAccentColor(self: App): Color3 return Colors.accent(self) end
function Application.SetAccentColor(self: App, color: Color3): ()
	assert(alive(self), "Menu was destroyed")
	Colors.validate(color)
	local record = self._preferences.Accent
	assert(record and not record.Scope.Closed, "Accent color control was destroyed")
	local handle = record.Handle :: ColorPickerHandle
	handle:Set(color)
end
function Application.SetBackgroundColor(self: App, color: Color3): ()
	assert(alive(self), "Menu was destroyed")
	Colors.validate(color)
	local record = self._background.Accent
	assert(record and not record.Scope.Closed, "Background color control was destroyed");
	(record.Handle :: ColorPickerHandle):Set(color)
end
function Application.SetBackgroundDim(self: App, dim: number): ()
	assert(alive(self) and finite(dim) and dim >= 0 and dim <= 1, "Background dimming expects 0..1")
	local record = self._background.Dimming
	assert(record and not record.Scope.Closed, "Background controls were destroyed");
	(record.Handle :: SliderHandle):Set(dim)
end
function Application.GetBackgroundStatus(self: App): { File: string?, Dim: number, Outcome: string }
	return { File = self._background.File, Dim = self._background.Dim, Outcome = self._background.Outcome }
end
function Application.GetBackgroundStats(self: App): IconStats
	return table.clone(self._background.Stats)
end
function Application.GetStatus(self: App): AppStatus
	return {
		Phase = self._life.Phase, Error = self._life.Error, Stage = self._life.Stage,
		CompletedStages = self._life.Completed, TotalStages = 4, Visible = self._life.Visible,
		Gesture = if self._input.Gesture then self._input.Gesture.Kind else nil,
		CursorOwned = self._capture.Active, TabCount = #self._tabs.Order,
	}
end
-- CFG is a single settings component, with an editable selector and an action
-- row. Only typed control values are persisted; popups and actions stay local.
function Configs.name(name: string): string
	assert(type(name) == "string", "Config name must be a string")
	if name:sub(-5) == ".json" then name = name:sub(1, -6) end
	assert(#name > 0 and #name <= 100 and name:match("^[%w_%-][%w_%- ]*$") and name:sub(-1) ~= " ",
		"Config name must use 1-100 letters, digits, spaces, underscores or hyphens")
	local upper = name:upper()
	assert(not ({ CON = true, PRN = true, AUX = true, NUL = true })[upper] and not upper:match("^COM%d$") and not upper:match("^LPT%d$"), "Reserved config name")
	return name
end
function Configs.disarm(app: App): ()
	local state = app._configs
	local pending = state.Confirmation
	if not pending then return end
	state.Confirmation = nil
	Resources.close(pending.Scope)
	if alive(app) and state.Scope and not state.Scope.Closed then Configs.paint(app) end
end
function Configs.confirm(app: App, action: string, name: string): boolean
	local state = app._configs
	local pending = state.Confirmation
	if pending and pending.Action == action and pending.Name == name and os.clock() < pending.Deadline then
		Configs.disarm(app)
		return true
	end
	Configs.disarm(app)
	local owned = scope()
	local confirmation = { Action = action, Name = name, Deadline = os.clock() + 2, Scope = owned }
	state.Confirmation = confirmation
	Resources.own(state.Scope or app._scope, owned)
	Resources.add(owned, function() if state.Confirmation == confirmation then state.Confirmation = nil end end)
	Resources.spawn(owned, function()
		task.wait(2)
		if state.Confirmation == confirmation then Configs.disarm(app) end
	end)
	Configs.paint(app)
	return false
end
function Configs.close(app: App, preserveConfirmation: boolean?): ()
	local state = app._configs
	for _, visual in state.ButtonStates do visual.Hovered, visual.Pressed = false, false end
	if not preserveConfirmation then Configs.disarm(app) end
	local owned = state.PopupScope
	state.PopupScope, state.Popup = nil, nil
	if owned then Resources.close(owned) end
	if state.Chevron and state.Scope and not state.Scope.Closed then Motion.to(app, state.Scope, state.Chevron, { Rotation = 180 }, 0.10) end
	if state.Scope and not state.Scope.Closed then Configs.paint(app) end
end
function Configs.interactive(app: App): boolean
	local state = app._configs
	return state.Ready and not state.Busy and Gui.showing(app) and state.Section ~= nil and Mini.hostVisible(state.Section)
		and not app._sections.Drag and not app._input.Gesture and not app._interaction.Assignment and not app._interaction.ConsumedPointer
end
function Configs.paint(app: App): ()
	local state = app._configs
	local ok, name = protected(Configs.name, if state.Name then state.Name.Text else "")
	local exists = ok and table.find(state.Names, name) ~= nil
	for action, button in state.Buttons do
		local enabled = state.Ready and not state.Busy and ok and (if action == "create" then not exists else exists)
		local pending = state.Confirmation
		local armed = enabled and pending ~= nil and pending.Action == action and pending.Name == name and os.clock() < pending.Deadline
		local visual = state.ButtonStates[action]
		button.Active = enabled
		button.Text = action .. (if armed then "?" else "")
		Controls.actionSurface(app, button, not enabled, visual.Pressed, visual.Hovered or armed, visual.Flashing)
		button.TextColor3 = if visual.Flashing then Colors.contrast(Colors.accent(app)) elseif enabled then Appearance.Value else Appearance.MutedText
	end
end
function Configs.flash(app: App, action: string): ()
	local state = app._configs
	local visual = state.ButtonStates[action]
	if not visual or not state.Scope or state.Scope.Closed then return end
	if visual.Feedback then Resources.close(visual.Feedback) end
	local owner = scope()
	visual.Feedback, visual.Flashing, visual.Pressed = owner, true, false
	Resources.own(state.Scope, owner)
	Resources.add(owner, function()
		if visual.Feedback == owner then visual.Feedback, visual.Flashing = nil, false end
	end)
	Configs.paint(app)
	Controls.flash(owner, function()
		Resources.close(owner)
		if alive(app) then Configs.paint(app) end
	end)
end
function Configs.ensure(app: App): ()
	local caps = app._configs.Capabilities
	assert(caps.IsFile and caps.ReadFile and caps.WriteFile and caps.ListFiles and caps.DeleteFile, "Config file access unavailable")
	if caps.IsFolder and caps.MakeFolder then
		for _, folder in { Paths.Root, Paths.Configs } do
			assert(alive(app), "Menu was destroyed")
			if not caps.IsFolder(folder) then caps.MakeFolder(folder) end
			assert(alive(app) and caps.IsFolder(folder), "Config folder unavailable")
		end
	end
end
function Configs.list(app: App): { string }
	local state, caps = app._configs, app._configs.Capabilities
	local files: any
	if state.Provider then files = state.Provider.List()
	else Configs.ensure(app); files = (caps.ListFiles :: (string) -> { string })(Paths.Configs .. "/") end
	assert(alive(app), "Menu was destroyed")
	assert(type(files) == "table", "Config List must return a table")
	local names, seen = {}, {}
	for _, file in files do
		if type(file) ~= "string" then continue end
		local name: string?
		if state.Provider then name = file
		else
			local normalized = file:gsub("\\", "/")
			local prefix = Paths.Configs .. "/"
			local basename = if normalized:sub(1, #prefix) == prefix then normalized:sub(#prefix + 1)
				else normalized:match("/atafami/configs/([^/]+)$") or normalized
			if basename:sub(-5) ~= ".json" then continue end
			local ok, checked = protected(Configs.name, basename)
			if not ok then continue end
			local exists = (caps.IsFile :: (string) -> boolean)(prefix .. checked .. ".json")
			assert(alive(app) and type(exists) == "boolean", "Invalid config file check")
			if exists then name = checked end
		end
		if name and not seen[name] then seen[name] = true; table.insert(names, name) end
	end
	table.sort(names)
	return names
end
function Configs.refresh(app: App): ()
	local state = app._configs
	local draft = if state.Name then state.Name.Text else nil
	local names = app:ListConfigs()
	local active = app:GetActiveConfig()
	assert(alive(app), "Menu was destroyed")
	state.Names = names
	if state.Name and state.Name.Text == draft and draft == "" and active and table.find(names, active) then
		state.Selected = active; state.Name.Text = active
	end
	Configs.paint(app)
end
function Configs.record(app: App, flag: string): ControlRecord
	assert(alive(app), "Menu was destroyed")
	assert(type(flag) == "string" and flag ~= "", "Flag must be a nonempty string")
	local record = app._values.ByFlag[flag]
	assert(record and not record.Scope.Closed, "Unknown Flag: " .. flag)
	return record
end
function Configs.value(record: ControlRecord): any
	local value: any = record.Model.Value
	if record.Kind == "ColorPicker" then return { R = math.round(value.R * 255), G = math.round(value.G * 255), B = math.round(value.B * 255) }
	elseif record.Kind == "Keybind" then return if value then { Type = if value.EnumType == Enum.KeyCode then "KeyCode" else "UserInputType", Name = value.Name } else nil
	elseif record.Kind == "MultiDropdown" then return table.clone(value) end
	return value
end
function Configs.snapshot(app: App): any
	assert(alive(app), "Menu was destroyed")
	local flags: { [string]: any } = {}
	for flag, record in app._values.ByFlag do
		local value = Configs.value(record :: any)
		flags[flag] = if record.Kind == "Keybind" and value == nil then { Type = "None" } else value
	end
	return { Version = 1, Flags = flags }
end
function Configs.encode(app: App): string
	local document = Configs.snapshot(app)
	local codec = app._env.Globals.json or getfenv(0).json
	return if type(codec) == "table" and type(codec.encode) == "function" then codec.encode(document, { sortKeys = true, emptyTableAsArray = false })
		else game:GetService("HttpService"):JSONEncode(document)
end
function Configs.decode(record: ControlRecord, value: any): any
	if record.Kind == "Toggle" then assert(type(value) == "boolean", "Invalid toggle value")
	elseif record.Kind == "Slider" then
		assert(finite(value), "Invalid slider value"); value = Sliders.normalize(record, value)
	elseif record.Kind == "Dropdown" then
		assert(type(value) == "string", "Config choice must be a string")
		if record == record.Owner._background.Selection and value ~= "Default" then Background.path(value)
		else assert(table.find(record.Model.Values, value), "Config choice is unavailable") end
	elseif record.Kind == "MultiDropdown" then
		assert(type(value) == "table", "Invalid multiple choice value"); value = Controls.selection(record.Model.Values, value)
	elseif record.Kind == "ColorPicker" then
		assert(type(value) == "table", "Invalid color value")
		for _, channel in { "R", "G", "B" } do
			assert(finite(value[channel]) and value[channel] >= 0 and value[channel] <= 255 and value[channel] % 1 == 0, "Invalid color channel: expected integer within 0..255")
		end
		value = Color3.fromRGB(value.R, value.G, value.B)
	elseif record.Kind == "Keybind" then
		if value == nil then return nil end
		assert(type(value) == "table", "Invalid keybind value")
		if value.Type == "None" then
			for key in value do assert(key == "Type", "Invalid empty keybind") end
			return nil
		end
		assert(type(value.Name) == "string" and (value.Type == "KeyCode" or value.Type == "UserInputType"), "Invalid keybind value")
		local category: any = if value.Type == "KeyCode" then Enum.KeyCode else Enum.UserInputType
		value = category[value.Name]
		assert(Controls.validKey(value), "Invalid keybind key")
	end
	return value
end
function Configs.load(app: App, bytes: string, options: ValueSetOptions?): ConfigLoadReport
	Controls.options(options)
	assert(#bytes <= 1024 * 1024, "Config exceeds 1 MiB")
	-- Match old's plain-table format. Executor JSON decoders can attach
	-- non-string metadata keys, which are not persisted control flags.
	local document = game:GetService("HttpService"):JSONDecode(bytes)
	return Configs.apply(app, document, options)
end
function Configs.apply(app: App, document: any, options: ValueSetOptions?): ConfigLoadReport
	assert(alive(app), "Menu was destroyed")
	Controls.options(options)
	if app._configs.Transform then document = app._configs.Transform(document) end
	assert(type(document) == "table" and document.Version == 1 and type(document.Flags) == "table", "Expected config Version 1 and Flags object")
	local names: { string } = {}
	for flag in document.Flags do assert(type(flag) == "string", "Config Flags require string keys"); table.insert(names, flag) end
	table.sort(names, function(a, b)
		local switchA, switchB = type(document.Flags[a]) == "boolean", type(document.Flags[b]) == "boolean"
		return if switchA ~= switchB then not switchA else a < b
	end)
	local report: ConfigLoadReport = { Applied = 0, Skipped = 0, Errors = {} }
	local plan: { { Flag: string, Apply: () -> (), Notify: () -> () } } = {}
	for _, flag in names do
		local ok, operation = protected(function()
			local record = Configs.record(app, flag)
			local value = Configs.decode(record :: any, document.Flags[flag])
			local changed = (options and options.Replay == true) or (if record.Kind == "MultiDropdown" then not Controls.sameArray(record.Model.Value, value) else record.Model.Value ~= value)
			return {
				Flag = flag,
				Apply = function() (record.Handle :: any):Set(value, { Emit = false }) end,
				Notify = function() if changed then Controls.emit(record :: any, value, options) end end,
			}
		end)
		if ok then table.insert(plan, operation)
		else report.Skipped += 1; table.insert(report.Errors, flag .. ": " .. tostring(operation)) end
	end
	Input.finish(app)
	local notifications: { () -> () } = {}
	for _, operation in plan do
		assert(alive(app), "Menu was destroyed")
		local ok, problem = protected(operation.Apply)
		if ok then report.Applied += 1; table.insert(notifications, operation.Notify)
		else report.Skipped += 1; table.insert(report.Errors, operation.Flag .. ": " .. tostring(problem)) end
	end
	-- Preserve defolt's coherent callbacks while tolerating bad/unknown flags like old.
	for _, notify in notifications do if not alive(app) then break end; notify() end
	return report
end
function Configs.call(app: App, operation: string, input: string?, options: ValueSetOptions?): any
	assert(alive(app), "Menu was destroyed")
	local state, caps = app._configs, app._configs.Capabilities
	assert(not state.Busy, "Config operation already in progress")
	if operation ~= "list" and operation ~= "active" then Configs.disarm(app) end
	local draft = if state.Name then state.Name.Text else nil
	state.Busy = true; Configs.paint(app)
	local ok, result = protected(function(): any
		if operation == "list" then return Configs.list(app) end
		if operation == "active" then
			local active = if state.Provider then state.Provider.GetActive() else state.Active
			assert(active == nil or type(active) == "string", "Config GetActive must return a name or nil")
			return active
		end
		assert(type(input) == "string", "Config name must be a string")
		local name = if state.Provider then input else Configs.name(input)
		local report: ConfigLoadReport? = nil
		if state.Provider then
			if operation == "load" then assert(options == nil, "Custom ConfigProvider does not support Load options"); state.Provider.Load(name)
			elseif operation == "delete" then state.Provider.Delete(name)
			else
				if operation == "create" then assert(not table.find(Configs.list(app), name), "Config already exists") end
				state.Provider.Save(name)
			end
		else
			Configs.ensure(app)
			local path = Paths.Configs .. "/" .. name .. ".json"
			local exists = (caps.IsFile :: (string) -> boolean)(path)
			assert(alive(app) and type(exists) == "boolean", "Invalid config file check")
			if operation == "load" then
				Controls.options(options); assert(exists, "Config does not exist")
				local bytes = (caps.ReadFile :: (string) -> string)(path)
				assert(alive(app) and type(bytes) == "string", "Invalid config read")
				report = Configs.load(app, bytes, options)
			elseif operation == "delete" then
				assert(exists, "Config does not exist"); (caps.DeleteFile :: (string) -> ())(path)
				assert(alive(app) and not (caps.IsFile :: (string) -> boolean)(path), "Config was not deleted")
			else
				assert(operation == "create" or operation == "save", "Unknown config action")
				if operation == "create" then assert(not exists, "Config already exists") end
				local bytes = Configs.encode(app)
				assert(#bytes <= 1024 * 1024, "Config exceeds 1 MiB")
				local previous = if exists then (caps.ReadFile :: (string) -> string)(path) else nil
				assert(alive(app), "Menu was destroyed")
				local written, failure = protected(function()
					(caps.WriteFile :: (string, string) -> ())(path, bytes)
					assert(alive(app), "Menu was destroyed")
					assert((caps.IsFile :: (string) -> boolean)(path) and (caps.ReadFile :: (string) -> string)(path) == bytes, "Config write verification failed")
				end)
				if not written then
					safe(function()
						if previous then (caps.WriteFile :: (string, string) -> ())(path, previous)
						elseif (caps.IsFile :: (string) -> boolean)(path) then (caps.DeleteFile :: (string) -> ())(path) end
					end)
					error(failure, 0)
				end
			end
			assert(alive(app), "Menu was destroyed")
			if operation == "delete" then if state.Active == name then state.Active = nil end
			else state.Active = name end
		end
		assert(alive(app), "Menu was destroyed")
		local listed, names = protected(Configs.list, app)
		if listed and alive(app) then state.Names = names elseif not listed then diagnostic("Config List: " .. tostring(names)) end
		if state.Name and state.Name.Text == draft and alive(app) then
			if operation ~= "delete" then state.Selected = name; state.Name.Text = name
			elseif draft == name or draft == name .. ".json" then state.Selected = nil; state.Name.Text = "" end
		end
		return report
	end)
	state.Busy = false
	if alive(app) then Configs.paint(app) end
	if not ok then error("Config " .. operation .. ": " .. tostring(result), 0) end
	assert(alive(app), "Menu was destroyed")
	return result
end
function Application.ListConfigs(self: App): { string } return Configs.call(self, "list", nil, nil) end
function Application.ExportConfig(self: App): any return Configs.snapshot(self) end
function Application.ApplyConfig(self: App, document: any, options: ValueSetOptions?): ConfigLoadReport
	assert(alive(self), "Menu was destroyed")
	assert(not self._configs.Busy, "Config operation already in progress")
	Configs.disarm(self)
	self._configs.Busy = true; Configs.paint(self)
	local ok, result = protected(Configs.apply, self, document, options)
	self._configs.Busy = false
	if alive(self) then Configs.paint(self) end
	if not ok then error(result, 0) end
	assert(alive(self), "Menu was destroyed")
	return result
end
function Application.GetActiveConfig(self: App): string?
	assert(alive(self), "Menu was destroyed")
	return if self._configs.Provider then Configs.call(self, "active", nil, nil) else self._configs.Active
end
function Application.SaveConfig(self: App, name: string): () Configs.call(self, "save", name, nil) end
function Application.LoadConfig(self: App, name: string, options: ValueSetOptions?): ConfigLoadReport? return Configs.call(self, "load", name, options) end
function Application.DeleteConfig(self: App, name: string): () Configs.call(self, "delete", name, nil) end
function Application.HasFlag(self: App, flag: string): boolean
	assert(alive(self), "Menu was destroyed"); assert(type(flag) == "string" and flag ~= "", "Flag must be a nonempty string")
	return self._values.ByFlag[flag] ~= nil
end
function Application.GetFlag(self: App, flag: string): FlagValue? return Configs.value(Configs.record(self, flag)) end
function Application.SetFlag(self: App, flag: string, value: FlagValue?, options: ValueSetOptions?): ()
	local record = Configs.record(self, flag)
	local decoded = Configs.decode(record :: any, value)
	local handle: any = record.Handle
	handle:Set(decoded, options)
end
function Application.ResetFlag(self: App, flag: string): ()
	local record = Configs.record(self, flag)
	local value: any = record.Model.Default
	if record.Kind == "Dropdown" then value = if table.find(record.Model.Values, value) then value else record.Model.Values[1]
	elseif record.Kind == "MultiDropdown" then
		local retained = {}
		for _, choice in record.Model.Values do if table.find(value, choice) then table.insert(retained, choice) end end
		value = retained
	end
	(record.Handle :: any):Set(value)
end
function Application.GetFlags(self: App): { [string]: FlagValue }
	assert(alive(self), "Menu was destroyed")
	local flags: { [string]: FlagValue } = {}
	for flag, record in self._values.ByFlag do flags[flag] = Configs.value(record :: any) end
	return flags
end
function Configs.run(app: App, action: string): ()
	if not Configs.interactive(app) then return end
	Configs.close(app, true)
	Configs.flash(app, action)
	local ok, problem = protected(function()
		local draft = (app._configs.Name :: TextBox).Text
		local name = Configs.name(draft)
		Configs.refresh(app)
		if not Configs.interactive(app) or not app._configs.Name or app._configs.Name.Text ~= draft then return end
		local exists = table.find(app._configs.Names, name) ~= nil
		assert(if action == "create" then not exists else exists, "Config existence changed; select the appropriate action")
		if action == "save" or action == "delete" then
			if not Configs.confirm(app, action, name) then return end
		else Configs.disarm(app) end
		local report = Configs.call(app, action, name, nil)
		if report and report.Skipped > 0 then diagnostic("Config Load: " .. table.concat(report.Errors, "; ")) end
	end)
	if not ok then Configs.disarm(app); diagnostic("Config " .. action .. ": " .. tostring(problem)) end
end
function Configs.toggle(app: App): ()
	local state = app._configs
	if state.Popup then Configs.close(app); return end
	if not Configs.interactive(app) or not app._icons.DropdownAsset then return end
	Controls.cancel(app)
	local ok, problem = protected(Configs.refresh, app)
	if not ok then diagnostic("Config List: " .. tostring(problem)); return end
	if not Configs.interactive(app) then return end
	local section = state.Section :: SectionRecord
	local owned = scope(); state.PopupScope = owned; Resources.own(state.Scope or section.Scope, owned)
	local root = create(app, "ScrollingFrame", "ConfigDropdown", app.OverlayRoot, Layers.Popup, {
		BackgroundColor3 = Appearance.Card, BackgroundTransparency = 0.08, ClipsDescendants = true,
		ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y, AutomaticCanvasSize = Enum.AutomaticSize.None,
		ElasticBehavior = Enum.ElasticBehavior.Never, Active = true,
	}, owned)
	state.Popup = root
	corner(app, root, 6, owned)
	local function place()
		if not state.Root or not app.OverlayRoot or not Configs.interactive(app) then Configs.close(app); return end
		local anchor = state.Root.AbsolutePosition
		local scroll = app._view.SettingsContent
		if scroll then
			local top, window = scroll.AbsolutePosition, scroll.AbsoluteWindowSize
			if anchor.Y < top.Y or anchor.Y + Appearance.ControlHeight > top.Y + window.Y then Configs.close(app); return end
		end
		local at, viewport = anchor - app.OverlayRoot.AbsolutePosition, app.OverlayRoot.AbsoluteSize
		local inset = math.min(Appearance.PopupInset, math.max(0, math.min(viewport.X, viewport.Y) / 2))
		local wanted = math.min(#state.Names, 6) * Appearance.OptionHeight + Appearance.PopupInset * 2
		local below = math.max(0, viewport.Y - inset - at.Y - Appearance.ControlHeight - 4)
		local above = math.max(0, at.Y - inset - 4)
		local upward = below < wanted and above > below
		local height = math.min(wanted, if upward then above else below)
		local width = math.min(state.Root.AbsoluteSize.X, math.max(0, viewport.X - inset * 2))
		if height <= 0 or width <= 0 then Configs.close(app); return end
		root.Size = UDim2.fromOffset(width, height)
		root.Position = UDim2.fromOffset(math.clamp(at.X, inset, math.max(inset, viewport.X - width - inset)),
			if upward then at.Y - height - 4 else at.Y + Appearance.ControlHeight + 4)
		root.CanvasSize = UDim2.fromOffset(0, #state.Names * Appearance.OptionHeight + Appearance.PopupInset * 2)
	end
	place()
	if owned.Closed then return end
	if state.Chevron and state.Scope then Motion.to(app, state.Scope, state.Chevron, { Rotation = 0 }, 0.10) end
	for index, name in state.Names do
		local selected = name == state.Selected
		local option = create(app, "TextButton", "Option_" .. index, root, Layers.Popup, {
			Position = UDim2.fromOffset(4, 4 + (index - 1) * Appearance.OptionHeight), Size = UDim2.new(1, -8, 0, Appearance.OptionHeight),
			BackgroundColor3 = Appearance.Selected, BackgroundTransparency = if selected then 0 else 1,
			Text = "", AutoButtonColor = false, Selectable = false,
		}, owned)
		corner(app, option, 4, owned)
		create(app, "TextLabel", "Value", option, Layers.Popup, {
			Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0), Text = name, FontFace = CONTROL_FACE,
			TextSize = 11, TextColor3 = Appearance.Value, TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 1,
		}, owned)
		Resources.connect(owned, option.MouseEnter, function() option.BackgroundTransparency = if selected then 0 else 0.5 end)
		Resources.connect(owned, option.MouseLeave, function() option.BackgroundTransparency = if selected then 0 else 1 end)
		Resources.connect(owned, option.Activated, function()
			if not Configs.interactive(app) then return end
			state.Selected = name; (state.Name :: TextBox).Text = name; Configs.close(app); Configs.paint(app)
		end)
	end
	Resources.connect(owned, app._env.Input.InputBegan, function(event: InputObject)
		if event.KeyCode == Enum.KeyCode.Escape then Configs.close(app)
		elseif Floating.pointer(event) then
			local at = Vector2.new(event.Position.X, event.Position.Y)
			if not Controls.contains(root, at) and not Controls.contains(state.Root, at) then Configs.close(app) end
		end
	end)
	Resources.connect(owned, (state.Root :: Frame):GetPropertyChangedSignal("AbsolutePosition"), place)
	Resources.connect(owned, (app.OverlayRoot :: Frame):GetPropertyChangedSignal("AbsoluteSize"), place)
	if app._view.SettingsContent then Resources.connect(owned, app._view.SettingsContent:GetPropertyChangedSignal("CanvasPosition"), function() Configs.close(app) end) end
	Resources.connect(owned, root.Destroying, function() if not owned.Closed then Configs.close(app) end end)
end
function Configs.build(app: App): ()
	local state = app._configs
	local section = state.Section
	if not section or not section.Body or state.Root then return end
	local owned = scope(); state.Scope = owned; Resources.own(section.Scope, owned)
	Resources.add(owned, function()
		Configs.close(app)
		local focused = app._env.Input:GetFocusedTextBox()
		if state.Name and focused == state.Name then safe(function() (state.Name :: TextBox):ReleaseFocus(false) end) end
		state.Root, state.Name, state.Arrow, state.Chevron, state.Section, state.Scope, state.Ready = nil, nil, nil, nil, nil, nil, false
		table.clear(state.Buttons); table.clear(state.ButtonStates); table.clear(state.Names)
	end)
	local root: Frame = create(app, "Frame", "ConfigManager", section.Body, Layers.Content, { Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, LayoutOrder = 1 }, owned)
	state.Root = root
	Resources.connect(owned, root.Destroying, function() if not owned.Closed then Resources.close(owned) end end)
	local picker = create(app, "Frame", "Selector", root, Layers.Content, {
		Size = UDim2.new(1, 0, 0, Appearance.ControlHeight), BackgroundColor3 = Appearance.Field, BackgroundTransparency = 0.2,
	}, owned)
	corner(app, picker, 6, owned)
	create(app, "UIStroke", "Outline", picker, nil, { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1, Color = Appearance.FieldOutline, Transparency = 0.45 }, owned)
	state.Name = create(app, "TextBox", "Name", picker, Layers.Content, {
		Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -36, 1, 0), BackgroundTransparency = 1,
		Text = "", PlaceholderText = "Config name...", PlaceholderColor3 = Appearance.MutedText, TextColor3 = Appearance.Value,
		FontFace = CONTROL_FACE, TextSize = 11, ClearTextOnFocus = false, MultiLine = false, TextXAlignment = Enum.TextXAlignment.Left,
	}, owned)
	state.Arrow = create(app, "TextButton", "Dropdown", picker, Layers.Content, {
		Position = UDim2.new(1, -28, 0, 0), Size = UDim2.fromOffset(28, Appearance.ControlHeight), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, Selectable = false,
	}, owned)
	state.Chevron = create(app, "ImageLabel", "Chevron", state.Arrow, Layers.Content, {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(13, 13),
		Image = app._icons.DropdownAsset or "", Rotation = 180, ImageColor3 = Appearance.Value, BackgroundTransparency = 1,
	}, owned)
	Resources.connect(owned, (state.Arrow :: TextButton).Activated, function() Configs.toggle(app) end)
	Resources.connect(owned, (state.Name :: TextBox):GetPropertyChangedSignal("Text"), function()
		Configs.disarm(app)
		if state.Name and state.Name.Text ~= state.Selected then state.Selected = nil end
		Configs.paint(app)
	end)
	Resources.connect(owned, (state.Name :: TextBox).Focused, function() Configs.close(app) end)
	Resources.connect(owned, app._env.Input.InputBegan, function(event: InputObject)
		if not state.Confirmation then return end
		if event.KeyCode == Enum.KeyCode.Escape then Configs.disarm(app)
		elseif Floating.pointer(event) and not Controls.contains(state.Root, Vector2.new(event.Position.X, event.Position.Y)) then Configs.disarm(app) end
	end)
	for index, action in { "load", "create", "save", "delete" } do
		local visual = { Hovered = false, Pressed = false, Flashing = false, Feedback = nil :: Scope? }
		state.ButtonStates[action] = visual
		local button = create(app, "TextButton", action, root, Layers.Content, {
			Position = UDim2.new((index - 1) / 4, (index - 1) * 1.5, 0, 30), Size = UDim2.new(0.25, -4.5, 0, 28),
			BackgroundColor3 = Appearance.Field, Text = action, FontFace = CONTROL_FACE, TextSize = 11,
			TextColor3 = Appearance.Value, TextStrokeTransparency = 1, AutoButtonColor = false, Selectable = false,
		}, owned)
		state.Buttons[action] = button; corner(app, button, 6, owned)
		create(app, "UIStroke", "Outline", button, nil, { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1, Color = Appearance.FieldOutline, Transparency = 0.45 }, owned)
		Resources.connect(owned, button.Activated, function() if button.Active then Configs.run(app, action) end end)
		Resources.connect(owned, button.MouseEnter, function() visual.Hovered = button.Active and Configs.interactive(app); Configs.paint(app) end)
		Resources.connect(owned, button.MouseLeave, function() visual.Hovered, visual.Pressed = false, false; Configs.paint(app) end)
		Resources.connect(owned, button.MouseButton1Down, function() visual.Pressed = button.Active and Configs.interactive(app); Configs.paint(app) end)
		Resources.connect(owned, button.MouseButton1Up, function() visual.Pressed = false; Configs.paint(app) end)
	end
	local caps = state.Capabilities
	state.Ready = state.Provider ~= nil or (caps.IsFile ~= nil and caps.ReadFile ~= nil and caps.WriteFile ~= nil and caps.ListFiles ~= nil and caps.DeleteFile ~= nil)
	if state.Ready then
		local ok, problem = protected(Configs.refresh, app)
		if not ok then diagnostic("Config List: " .. tostring(problem)) end
	end
	Configs.paint(app)
end
local function buildSettings(app: App, config: Options): ()
	local tab = (app._tabs.Settings :: TabRecord).Handle :: TabHandle
	local interface = tab:AddSection({ Id = "interface", Name = "Interface" })
	local binding = interface:AddKeybind({ Id = "menu-keybind", Name = "Menu Keybind", Default = app._preferences.InitialKey })
	local animations = interface:AddToggle({ Id = "animations", Name = "Animations", Default = app._preferences.InitialAnimations })
	local theme = interface:AddColorPicker({ Id = "accent", Name = "Accent color", Default = app._preferences.AccentColor })
	app._preferences.Accent = (theme :: ColorPickerInternal)._record
	app._preferences.MenuBinding = (binding :: KeybindInternal)._record
	app._preferences.Animations = (animations :: ToggleInternal)._record
	local backgrounds = tab:AddSection({ Id = "background", Name = "Background" })
	local choices = Background.list(app)
	local selected = config.BackgroundFile or (if table.find(choices, DEFAULT_BACKGROUND) then DEFAULT_BACKGROUND else "Default")
	if not table.find(choices, selected) then table.insert(choices, selected) end
	local image = backgrounds:AddDropdown({ Id = "image", Name = "Image", Values = choices, Default = selected })
	local dim = backgrounds:AddSlider({ Id = "dim", Name = "Dimming", Min = 0, Max = 1, Step = 0.01, Default = app._background.Dim })
	local accent = backgrounds:AddColorPicker({ Id = "accent", Name = "Background color", Default = app._background.Color })
	app._background.Selection = (image :: DropdownInternal)._record
	app._background.Dimming = (dim :: SliderInternal)._record
	app._background.Accent = (accent :: ColorPickerInternal)._record
	app._background.File = if selected == "Default" then nil else selected
	backgrounds:AddButton({ Id = "refresh", Name = "Refresh images", Callback = function() app:RefreshBackgrounds() end })
	local cfg = tab:AddSection({ Id = "cfg", Name = "Config" })
	app._configs.Section = (cfg :: SectionInternal)._record
	local session = tab:AddSection({ Id = "session", Name = "Session" })
	Controls.addButton((session :: SectionInternal)._record, { Id = "reload-menu", Name = "Reload Menu", Disabled = config.OnReload == nil, Callback = function() app:Reload() end }, true)
	Controls.addButton((session :: SectionInternal)._record, { Id = "unload", Name = "Unload", Disabled = config.OnUnload == nil, Callback = function() app:Unload() end }, true)
	local links = tab:AddSection({ Id = "links", Name = "Links" })
	links:AddButton({ Id = "discord", Name = "Discord", Icon = DISCORD_ICON, Disabled = config.OnDiscord == nil, Callback = config.OnDiscord })
end
function Application.new(options: Options?): App
	assert(options == nil or type(options) == "table", "new options require a table")
	local config: Options = options or {}
	-- Validate arguments before replacing a live owner or allocating resources.
	vector(config.Position, Vector2.zero); vector(config.Size, Appearance.Initial)
	assert(config.Visible == nil or type(config.Visible) == "boolean", "Visible expects boolean")
	assert(config.Parent == nil or typeof(config.Parent) == "Instance", "Parent expects Instance")
	assert(config.IconCapabilities == nil or type(config.IconCapabilities) == "table", "IconCapabilities expects table")
	assert(config.ConfigTransform == nil or type(config.ConfigTransform) == "function", "ConfigTransform expects function")
	assert(config.ConfigCapabilities == nil or type(config.ConfigCapabilities) == "table", "ConfigCapabilities expects table")
	if config.ConfigProvider ~= nil then
		assert(type(config.ConfigProvider) == "table", "ConfigProvider expects table")
		for _, method in { "List", "GetActive", "Save", "Load", "Delete" } do assert(type((config.ConfigProvider :: any)[method]) == "function", "ConfigProvider." .. method .. " expects function") end
	end
	assert(Controls.validKey(config.MenuKeybind), "MenuKeybind requires keyboard key, mouse button, or nil")
	assert(config.AnimationsEnabled == nil or type(config.AnimationsEnabled) == "boolean", "AnimationsEnabled expects boolean")
	assert(config.OnReload == nil or type(config.OnReload) == "function", "OnReload expects a build function returning a new defolt instance")
	assert(config.OnUnload == nil or type(config.OnUnload) == "function", "OnUnload expects function")
	assert(config.OnDiscord == nil or type(config.OnDiscord) == "function", "OnDiscord expects function")
	if config.BackgroundFile ~= nil then Background.path(config.BackgroundFile) end
	assert(config.BackgroundDim == nil or (finite(config.BackgroundDim) and config.BackgroundDim >= 0 and config.BackgroundDim <= 1), "BackgroundDim expects 0..1")
	if config.BackgroundColor ~= nil then Colors.validate(config.BackgroundColor) end
	if config.AccentColor ~= nil then Colors.validate(config.AccentColor) end
	assert(config.ScriptVersion == nil or (type(config.ScriptVersion) == "string" and #config.ScriptVersion <= 64 and config.ScriptVersion:match("%S") ~= nil and not config.ScriptVersion:find("%c")), "ScriptVersion expects a nonempty single-line string up to 64 bytes")
	local capabilities: { [string]: any } = (config.IconCapabilities :: any) or {}
	for _, value in capabilities do assert(type(value) == "function", "Icon capabilities expect functions") end
	for _, value in (config.ConfigCapabilities or {}) :: any do assert(type(value) == "function", "Config capabilities expect functions") end
	local timeout = if config.BootstrapTimeout == nil then 15 else config.BootstrapTimeout
	local iconTimeout = if config.IconTimeout == nil then 6 else config.IconTimeout
	assert(finite(timeout) and finite(iconTimeout), "Timeouts must be finite")
	assert(config.Tabs == nil or type(config.Tabs) == "table", "Tabs expects a dense array")
	assert(config.Search == nil or type(config.Search) == "table", "Search expects table")
	assert(config.Settings == nil or type(config.Settings) == "table", "Settings expects table")
	local ids: { [string]: boolean } = { search = true, settings = true }
	local count = 0
	local requestedTabs: { TabOptions } = config.Tabs or {}
	for key, tab in requestedTabs do
		assert(type(key) == "number" and key % 1 == 0 and key >= 1 and key <= #requestedTabs, "Tabs expects a dense array")
		Tabs.validate(tab)
		assert(not ids[tab.Id], "Duplicate or reserved tab Id: " .. tab.Id); ids[tab.Id] = true; count += 1
	end
	assert(count == #requestedTabs, "Tabs expects a dense array")
	local search: TabBehavior = config.Search or {}
	local settings: TabBehavior = config.Settings or {}
	local behaviors: { TabBehavior } = { search, settings }
	for _, behavior in behaviors do
		assert(type(behavior) == "table", "Tab behavior expects table")
		assert(behavior.Active == nil or type(behavior.Active) == "boolean", "Tab Active expects boolean")
		assert(behavior.Callback == nil or type(behavior.Callback) == "function", "Tab Callback expects function")
	end
	local env = Runtime.discover(config.IconCapabilities)
	local base = getfenv(0)
	local configCaps: ConfigCapabilities = if config.ConfigCapabilities then table.clone(config.ConfigCapabilities) else {
		IsFile = env.Globals.isfile or base.isfile, ReadFile = env.Globals.readfile or base.readfile, WriteFile = env.Globals.writefile or base.writefile,
		IsFolder = env.Globals.isfolder or base.isfolder, MakeFolder = env.Globals.makefolder or base.makefolder,
		ListFiles = env.Globals.listfiles or base.listfiles, DeleteFile = env.Globals.delfile or base.delfile,
	}
	configCaps.IsFolder, configCaps.MakeFolder = configCaps.IsFolder or env.Capabilities.IsFolder, configCaps.MakeFolder or env.Capabilities.MakeFolder
	local rebuilding = Reload.Workers[coroutine.running()]
	assert(not rebuilding or (rebuilding.Pending and not rebuilding.Cancelled), "Cannot create a menu from a cancelled Reload")
	local pending: ReloadGate? = env.Globals[RELOAD_SLOT]
	if pending and pending ~= rebuilding then Reload.cancel(pending, env.Globals) end
	local previous = env.Globals[INSTANCE_SLOT]
	if previous then
		local ok, released = protected(function() previous:Destroy(); return previous:IsDestroyed() end)
		assert(ok and released, "Previous foundation could not release ownership: " .. tostring(released))
		assert(env.Globals[INSTANCE_SLOT] == nil or env.Globals[INSTANCE_SLOT] == previous, "Previous cleanup created another menu owner")
	end
	timeout, iconTimeout = math.clamp(timeout, 0.25, 30), math.clamp(iconTimeout, 0.1, 15)
	local id = game:GetService("HttpService"):GenerateGUID(false)
	local self: App = setmetatable({
		_env = env, _scope = scope(), _boot = scope(), _view = {},
		_metrics = { TextMeasurements = 0, LayoutPasses = 0, SearchPasses = 0, PopupPaintWrites = 0 },
		_search = { Query = "", Editing = false, Dirty = true, Revision = 0, Sections = {}, Controls = {}, Collapsed = {}, SectionCount = 0, ControlCount = 0 },
		_settings = { Columns = 1, CanvasHeight = 0 },
		_configs = { Capabilities = configCaps, Provider = config.ConfigProvider, Transform = config.ConfigTransform, Buttons = {}, ButtonStates = {}, Names = {}, Busy = false, Ready = false },
		_preferences = { InitialKey = config.MenuKeybind or Enum.KeyCode.RightShift, InitialAnimations = config.AnimationsEnabled ~= false, Restoring = rebuilding ~= nil,
			AccentColor = config.AccentColor or Appearance.White,
			ScriptVersion = config.ScriptVersion,
			OnReload = config.OnReload, OnUnload = config.OnUnload, Unloading = false },
		_motion = { Scope = scope(), FinishLayout = true, Target = "", Presented = {}, Tracks = {}, Closing = {}, Alphas = {} },
		_life = { Phase = "loading", Visible = false, RequestedVisible = config.Visible ~= false and rebuilding == nil,
			Completed = 0, Stage = "shell", Timeout = timeout, IconTimeout = iconTimeout, Deadline = os.clock() + timeout },
		_geometry = { Position = vector(config.Position, Vector2.zero), Size = vector(config.Size, Appearance.Initial),
			Viewport = Vector2.zero, Initialized = config.Position ~= nil },
		_input = { Gesture = nil, Scope = scope(), ResizeHovered = false },
		_tabs = { Order = {}, ById = {} },
		_sections = { Scope = scope(), ByTab = {}, Order = {}, Reordered = false, Queued = false, Columns = 1, CardWidth = 260, CanvasHeight = 0,
			DragIconOutcome = "pending", CollapseIconOutcome = "pending", HeaderIconsStarted = false },
		_icons = { Scope = scope(), Cache = {}, Jobs = {}, ButtonAssets = {}, DropdownOutcome = "unused", DropdownStarted = false, GearStarted = false, GearOutcome = "unused", Stats = { DiskHits = 0, MemoryHits = 0, WorkerStarts = 0, NetworkRequests = 0, CorruptCache = 0, Failures = 0, Pending = 0 } },
		_background = { Scope = scope(), File = config.BackgroundFile, Dim = config.BackgroundDim or 0.28, Color = config.BackgroundColor or Appearance.Background, Revision = 0, Outcome = "default", Stats = { DiskHits = 0, MemoryHits = 0, WorkerStarts = 0, NetworkRequests = 0, CorruptCache = 0, Failures = 0, Pending = 0 } },
		_values = { Scope = scope(), BySection = {}, ByPath = {}, ByFlag = {} },
		_buttons = { Scope = scope(), BySection = {}, ByPath = {} },
		_minis = { Scope = scope(), Order = {}, ByControl = {}, Chain = {} },
		_interaction = {},
		_capture = { Active = false, Writing = false, RenderAfter = "AtafamiUIAfter_" .. id, Action = "AtafamiUIMouse_" .. id },
	}, Application) :: any
	env.Globals[INSTANCE_SLOT] = self
	if rebuilding then
		rebuilding.Candidate = self
		local detach = Resources.add(self._scope, function() if rebuilding.Pending then Reload.cancel(rebuilding, env.Globals) end end)
		Resources.add(rebuilding.Scope, detach)
	end
	Resources.own(self._scope, self._motion.Scope)
	Resources.add(self._motion.Scope, function() Motion.cancel(self); table.clear(self._motion.Presented) end)
	Resources.add(self._scope, function() Resources.close(self._sections.Scope); self._sections.DragAsset, self._sections.CollapseAsset = nil, nil end)
	Resources.add(self._sections.Scope, function() Sections.cancelDrag(self) end)
	Resources.add(self._scope, function() Resources.close(self._icons.Scope); self._icons.DropdownAsset, self._icons.GearAsset = nil, nil; table.clear(self._icons.Cache); table.clear(self._icons.ButtonAssets) end)
	Resources.own(self._scope, self._background.Scope)
	Resources.add(self._scope, function() Mini.destroyAll(self) end)
	Resources.add(self._scope, function()
		safe(function() Controls.cancel(self) end)
		Resources.close(self._values.Scope); Resources.close(self._buttons.Scope)
		table.clear(self._values.BySection); table.clear(self._buttons.BySection)
		table.clear(self._values.ByPath); table.clear(self._buttons.ByPath)
		table.clear(self._values.ByFlag)
	end)
	local ok, problem = protected(function()
		for _, tab in requestedTabs do self:AddTab(tab) end
		local search: TabBehavior = config.Search or {}
		self:AddTab({ Id = "search", Name = "Search", Icon = "tabler--search.png",
			Active = search.Active, Callback = search.Callback })
		self._tabs.Search = self._tabs.ById.search
		local behavior: TabBehavior = config.Settings or {}
		self:AddTab({ Id = "settings", Name = "Settings", Icon = "tabler--settings.png",
			Active = behavior.Active, Callback = behavior.Callback })
		self._tabs.Settings = self._tabs.ById.settings
		if (self._tabs.Search :: TabRecord).Active then
			if (self._tabs.Settings :: TabRecord).Active then (self._tabs.Search :: TabRecord).Active = false
			else self._search.Editing = true end
		end
		Gui.shell(self, Runtime.parent(self, config.Parent))
		buildSettings(self, config)
	end)
	if not ok then self:_fail(tostring(problem)); return self end
	Resources.spawn(self._boot, function()
		while self._life.Phase == "loading" and os.clock() < self._life.Deadline do task.wait() end
		if self._life.Phase == "loading" then self:_fail("bootstrap deadline exceeded (" .. timeout .. "s)") end
	end)
	Resources.spawn(self._boot, function() Bootstrap.run(self) end)
	return self
end

return table.freeze({
	Kind = "ScriptUIFoundation", Variant = "defolt", Version = "1.22.2", ContractVersion = 1,
	new = Application.new, Layers = Layers, DisplayOrder = DISPLAY_ORDER,
	IconCacheDirectory = Paths.Icons, GetIconCachePath = Icons.path,
	ConfigDirectory = Paths.Configs,
	BackgroundCacheDirectory = Paths.Background, GetBackgroundCachePath = Background.path,
})
