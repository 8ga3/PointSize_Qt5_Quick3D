#ifndef POINTCLOUDCUBEGEOMETRY_H
#define POINTCLOUDCUBEGEOMETRY_H

#include <QQuick3DGeometry>

class PointCloudCubeGeometry : public QQuick3DGeometry
{
    Q_OBJECT
    QML_NAMED_ELEMENT(PointCloudCubeGeometry)
    Q_PROPERTY(qreal pointCount READ pointCount WRITE setPointCount NOTIFY pointCountChanged)

public:
    PointCloudCubeGeometry();

    qreal pointCount() const
    {
        return m_fPointCount;
    }

    void setPointCount(qreal value)
    {
        if (m_fPointCount != value) {
            m_fPointCount = value;
            update();
            updateData();
            emit pointCountChanged();
        }
    }

signals:
    void pointCountChanged();

private:
    qreal m_fPointCount;

    void updateData();
    float randomFloat(const float lowest, const float highest);
};

#endif // POINTCLOUDCUBEGEOMETRY_H
