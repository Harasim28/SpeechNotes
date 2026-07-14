#ifndef NOTEMODEL_H
#define NOTEMODEL_H

#include <QAbstractListModel>
#include <QString>
#include <QDateTime>

struct Note {
    QString id;
    QString title;
    QString text;
    QString audioPath;
    QDateTime createdAt;
    int durationSec;
};

class NoteModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        TextRole,
        AudioPathRole,
        CreatedAtRole,
        DurationRole
    };

    explicit NoteModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addNote(const QString &title, const QString &text,
                             const QString &audioPath, int durationSec);
    Q_INVOKABLE void removeNote(int index);
    Q_INVOKABLE void clearAll();
    Q_INVOKABLE QString getNoteText(int index) const;

signals:
    void countChanged();

private:
    QList<Note> m_notes;
    void saveToFile();
    void loadFromFile();
};

#endif // NOTEMODEL_H
