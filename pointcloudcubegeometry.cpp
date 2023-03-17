#include "pointcloudcubegeometry.h"
#include <QRandomGenerator>
#include <QVector3D>

constexpr int NUM_POINTS = 10000;

PointCloudCubeGeometry::PointCloudCubeGeometry()
    : m_fPointCount(NUM_POINTS)
{
    updateData();
}

void PointCloudCubeGeometry::updateData()
{
    clear();

    constexpr int stride = 5 * sizeof(float);
    constexpr float width = 0.05f;

    QByteArray vertexData;
    vertexData.resize(m_fPointCount * stride * 4);
    float *p = reinterpret_cast<float *>(vertexData.data());

    QByteArray indexes;
    indexes.resize(m_fPointCount * sizeof(uint32_t) * 3 * 2);
    uint32_t *idx = reinterpret_cast<uint32_t *>(indexes.data());


    for (int i = 0; i < m_fPointCount; ++i) {
        float x = randomFloat(-5.0f, +5.0f);
        float y = randomFloat(-5.0f, +5.0f);
        float z = randomFloat(-5.0f, +5.0f);

        // vertex
        for (int j = 0; j < 4; ++j) {
            *p++ = x;
            *p++ = y;
            *p++ = z;
            *p++ = float(((j+1) >> 1) & 1); // Texture u
            *p++ = float(( j    >> 1) & 1); // Texture v
        }

        // index
        *idx++ = i * 4;
        *idx++ = i * 4 + 1;
        *idx++ = i * 4 + 2;

        *idx++ = i * 4;
        *idx++ = i * 4 + 2;
        *idx++ = i * 4 + 3;
    }

    setName("PointCloudCubeGeometry");
    setVertexData(vertexData);
    setStride(stride);
    setIndexData(indexes);
    setBounds(QVector3D(-5.0f - width, -5.0f - width, -5.0f - width), QVector3D(+5.0f + width, +5.0f + width, +5.0f + width));

    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Triangles);

    addAttribute(QQuick3DGeometry::Attribute::PositionSemantic,
                 0,
                 QQuick3DGeometry::Attribute::F32Type);
    addAttribute(QQuick3DGeometry::Attribute::TexCoordSemantic,
                 3 * sizeof(float),
                 QQuick3DGeometry::Attribute::F32Type);
    addAttribute(QQuick3DGeometry::Attribute::IndexSemantic,
                 0,
                 QQuick3DGeometry::Attribute::U32Type);
}

float PointCloudCubeGeometry::randomFloat(const float lowest, const float highest)
{
    return lowest + QRandomGenerator::global()->generateDouble() * (highest - lowest);
}
