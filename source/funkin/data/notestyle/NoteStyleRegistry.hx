package funkin.data.notestyle;

import funkin.play.notes.notestyle.NoteStyle;
import funkin.play.notes.notestyle.ScriptedNoteStyle;
import funkin.data.notestyle.NoteStyleData;

class NoteStyleRegistry extends BaseRegistry<NoteStyle, NoteStyleData>
{
  /**
   * The current version string for the note style data format.
   * Handle breaking changes by incrementing this value
   * and adding migration to the `migrateNoteStyleData()` function.
   */
  public static final NOTE_STYLE_DATA_VERSION:thx.semver.Version = "1.0.0";

  public static final NOTE_STYLE_DATA_VERSION_RULE:thx.semver.VersionRule = "1.0.x";

  public static final DEFAULT_NOTE_STYLE_ID:String = "funkin";

  public static final instance:NoteStyleRegistry = new NoteStyleRegistry();

  public function new()
  {
    super('NOTESTYLE', 'notestyles', NOTE_STYLE_DATA_VERSION_RULE);
  }

  public function fetchDefault():NoteStyle
  {
    return fetchEntry(DEFAULT_NOTE_STYLE_ID);
  }

  /**
   * Read, parse, and validate the JSON data and produce the corresponding data object.
   */
  public function parseEntryData(id:String):Null<NoteStyleData>
  {
    // JsonParser does not take type parameters,
    // otherwise this function would be in BaseRegistry.
    var parser = new json2object.JsonParser<NoteStyleData>();

    switch (loadEntryFile(id))
    {
      case {fileName: fileName, contents: contents}:
        parser.fromJson(contents, fileName);
      default:
        return null;
    }

    if (parser.errors.length > 0)
    {
      printErrors(parser.errors, id);
      return null;
    }
    return parser.value;
  }

  function createScriptedEntry(clsName:String):NoteStyle
  {
    return ScriptedNoteStyle.init(clsName, "unknown");
  }

  function getScriptedClassNames():Array<String>
  {
    return ScriptedNoteStyle.listScriptClasses();
  }
}