#include "notemodel.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDebug>
#include <QDir>

NoteModel::NoteModel(QObject *parent) : QAbstractListModel(parent)
{
    loadFromFile();
}

int NoteModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_notes.count();
}

QVariant NoteModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_notes.count())
        return QVariant();

    const Note &note = m_notes.at(index.row());

    switch (role) {
    case IdRole: return note.id;
    case TitleRole: return note.title;
    case TextRole: return note.text;
    case AudioPathRole: return note.audioPath;
    case CreatedAtRole: return note.createdAt;
    case DurationRole: return note.durationSec;
    default: return QVariant();
    }
}

QHash<int, QByteArray> NoteModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "noteId";
    roles[TitleRole] = "title";
    roles[TextRole] = "text";
    roles[AudioPathRole] = "audioPath";
    roles[CreatedAtRole] = "createdAt";
    roles[DurationRole] = "duration";
    return roles;
}

void NoteModel::addNote(const QString &title, const QString &text,
                        const QString &audioPath, int durationSec)
{
    if (text.isEmpty())
        return;

    Note note;
    note.id = QString::number(QDateTime::currentMSecsSinceEpoch());
    note.title = title.isEmpty() ? text.left(30) + "..." : title;
    note.text = text;
    note.audioPath = audioPath;
    note.createdAt = QDateTime::currentDateTime();
    note.durationSec = durationSec;

    beginInsertRows(QModelIndex(), 0, 0);
    m_notes.prepend(note);
    endInsertRows();

    emit countChanged();
    saveToFile();

    qDebug() << "📝 Note added:" << note.title;
}

void NoteModel::removeNote(int index)
{
    if (index < 0 || index >= m_notes.count())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_notes.removeAt(index);
    endRemoveRows();

    emit countChanged();
    saveToFile();

    qDebug() << "🗑️ Note removed at index:" << index;
}

void NoteModel::clearAll()
{
    if (m_notes.isEmpty())
        return;

    beginResetModel();
    m_notes.clear();
    endResetModel();

    emit countChanged();
    saveToFile();

    qDebug() << "🗑️ All notes cleared";
}

QString NoteModel::getNoteText(int index) const
{
    if (index < 0 || index >= m_notes.count())
        return QString();

    return m_notes.at(index).text;
}

void NoteModel::saveToFile()
{
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dataDir);

    QFile file(dataDir + "/notes.json");
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Cannot save notes:" << file.errorString();
        return;
    }

    QJsonArray array;
    for (const Note &note : m_notes) {
        QJsonObject obj;
        obj["id"] = note.id;
        obj["title"] = note.title;
        obj["text"] = note.text;
        obj["audioPath"] = note.audioPath;
        obj["createdAt"] = note.createdAt.toString(Qt::ISODate);
        obj["durationSec"] = note.durationSec;
        array.append(obj);
    }

    file.write(QJsonDocument(array).toJson());
    qDebug() << "💾 Saved" << m_notes.count() << "notes";
}

void NoteModel::loadFromFile()
{
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QFile file(dataDir + "/notes.json");
    if (!file.exists())
        return;

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot load notes:" << file.errorString();
        return;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isArray())
        return;

    QJsonArray array = doc.array();
    m_notes.clear();

    for (const QJsonValue &value : array) {
        QJsonObject obj = value.toObject();
        Note note;
        note.id = obj["id"].toString();
        note.title = obj["title"].toString();
        note.text = obj["text"].toString();
        note.audioPath = obj["audioPath"].toString();
        note.createdAt = QDateTime::fromString(obj["createdAt"].toString(), Qt::ISODate);
        note.durationSec = obj["durationSec"].toInt();

        if (!note.id.isEmpty() && !note.text.isEmpty()) {
            m_notes.append(note);
        }
    }

    emit countChanged();
    qDebug() << "📂 Loaded" << m_notes.count() << "notes from file";
}
