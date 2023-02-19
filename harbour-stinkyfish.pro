# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-stinkyfish

CONFIG += sailfishapp_qml

SOURCES += 

OTHER_FILES += qml/harbour-stinkyfish.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-stinkyfish.changes.in \
    rpm/harbour-stinkyfish.spec \
    rpm/harbour-stinkyfish.yaml \
    translations/*.ts \
    qml/python/entry_point.py \
    qml/python/file_database.py \
    qml/python/node_cache.py \
    qml/python/node_id_generator.py \
    qml/python/node_manager.py \
    qml/python/node_factory.py \
    qml/python/node.py \
    qml/python/note_node.py \
    qml/python/todo_node.py \
    qml/python/pyologger.py \
    qml/python/PyOrgMode.py \
    harbour-stinkyfish.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-stinkyfish-de.ts

DISTFILES += \
    qml/Delegates/BaseNode.qml \
    qml/Delegates/NodeCalcDelegate.qml \
    qml/Delegates/NodeNoteDelegate.qml \
    qml/Delegates/NodeTodoDelegate.qml \
    qml/js/Database.js \
    qml/pages/NodePage.qml \
    qml/delegates/BaseNode.qml \
    qml/delegates/NodeCalcDelegate.qml \
    qml/delegates/NodeNoteDelegate.qml \
    qml/delegates/NodeTodoDelegate.qml \
    qml/pages/AddItemPage.qml \
    qml/pages/SettingsPage.qml
