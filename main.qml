import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick3D 1.15
import QtQuick3D.Helpers 1.15
import QtQuick3D.Materials 1.15
import PointCloudCube 1.0

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Point Size")
    color: Qt.rgba(0.95, 1.0, 1.0, 1.0)

    CustomMaterial {
        id: pcCubeMaterial
        objectName: "pcCubeMaterial"

        property real length: _sliderSize.value
        property real yaw: 0
        property real pitch: 0

        shaderInfo: ShaderInfo {
            version: "330"
            type: "GLSL"
        }

        Shader {
            id: vertShader
            stage: Shader.Vertex
            shader: "ChangePoints.vert"
        }

        Shader {
            id: fragShader
            stage: Shader.Fragment
            shader: "ChangePoints.frag"
        }

        passes: [ Pass {
                shaders: [ vertShader, fragShader ]
            }
        ]
    }

    View3D {
        id: mainView3d
        anchors.fill: parent
        camera: cameraPerspective

        PerspectiveCamera {
            id: cameraPerspective
            position: Qt.vector3d(0, 0, 300)
        }

        OrthographicCamera {
            id: cameraOrthographic
            position: Qt.vector3d(0, 0, 300)
            scale: Qt.vector3d(scale_size, scale_size, scale_size)

            property real scale_size: (cube.scale.x * 10.0) / (mainView3d.width < mainView3d.height ? mainView3d.width : mainView3d.height) * Math.SQRT2 / Screen.devicePixelRatio
        }

        WasdController {
            id: wasdController
            controlledObject: cube
            keysEnabled: true
            ySpeed: 1
            xSpeed: 1
        }

        Model {
            id: cube
            scale: Qt.vector3d(20, 20, 20)
            geometry: PointCloudCubeGeometry {
                pointCount: _sliderPoints.value
            }
            materials: [pcCubeMaterial]

            onEulerRotationChanged: {
                pcCubeMaterial.yaw = eulerRotation.y / 180 * Math.PI
                pcCubeMaterial.pitch = eulerRotation.x / 180 * Math.PI
            }

            Component.onCompleted: {
                pcCubeMaterial.yaw = eulerRotation.y / 180 * Math.PI
                pcCubeMaterial.pitch = eulerRotation.x / 180 * Math.PI
            }
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        opacity: 0.75

        Label {
            property var profile: ["", "Core", "Compat"]
            text: "OpenGL: " + OpenGLInfo.majorVersion + '.' + OpenGLInfo.minorVersion + ' ' + profile[OpenGLInfo.profile]
        }

        RowLayout {
            spacing: 4

            RadioButton {
                checked: true
                text: qsTr("Perspective")
                onCheckedChanged: mainView3d.camera = cameraPerspective
            }

            RadioButton {
                text: qsTr("Orthographic")
                onCheckedChanged: mainView3d.camera = cameraOrthographic
            }
        }

        RowLayout {
            spacing: 4

            Slider {
                id: _sliderPoints
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                snapMode: RangeSlider.SnapAlways
                value: 10000
                stepSize: 10000
                from: 10000
                to: 1000000
            }

            Text {
                Layout.minimumWidth: 120
                Layout.maximumWidth: 120
                verticalAlignment: Text.AlignVCenter
                text: _sliderPoints.value.toFixed(0)
                font.pixelSize: 24
            }
        }

        RowLayout {
            spacing: 4

            Slider {
                id: _sliderSize
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                snapMode: RangeSlider.SnapAlways
                value: 0.01
                stepSize: 0.01
                from: 0.01
                to: 1.00
            }

            Text {
                Layout.minimumWidth: 120
                Layout.maximumWidth: 120
                verticalAlignment: Text.AlignVCenter
                text: _sliderSize.value.toFixed(2)
                font.pixelSize: 24
            }
        }
    }
}
