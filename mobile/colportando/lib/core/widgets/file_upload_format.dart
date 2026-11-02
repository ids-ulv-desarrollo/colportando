import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Selector y cargador de archivos, documentos y fotos de cámara o galería.
class FileUploadFormat extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback? onRemove;
  final ValueChanged<String>? onFileSelected;
  final bool allowCamera;
  final FileType fileType;
  final List<String>? allowedExtensions;

  const FileUploadFormat({
    super.key,
    required this.label,
    this.fileName,
    this.onRemove,
    this.onFileSelected,
    this.allowCamera = true,
    this.fileType = FileType.any,
    this.allowedExtensions,
  });

  Future<void> _pickFromFile() async {
    final result = await FilePicker.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );
    final path = result.firstOrNull?.path;
    if (path != null) {
      onFileSelected?.call(path);
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      onFileSelected?.call(photo.path);
    }
  }

  void _showSelectionSheet(BuildContext context) {
    if (!allowCamera) {
      _pickFromFile();
      return;
    }

    BottomSheetFormat(
      title: label,
      children: [
        ListTile(
          leading: AppIcon.camera,
          title: TextFormat.body("Tomar foto con cámara"),
          onTap: () {
            Navigator.pop(context);
            _pickFromCamera();
          },
        ),
        ListTile(
          leading: AppIcon.file,
          title: TextFormat.body("Seleccionar archivo"),
          onTap: () {
            Navigator.pop(context);
            _pickFromFile();
          },
        ),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null && fileName!.isNotEmpty;

    return ContainerFormat(
      onPressed: () => _showSelectionSheet(context),
      children: [
        Row(
          children: [
            hasFile ? AppIcon.file : AppIcon.upload,
            AppSpacing.widthSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormat.body(hasFile ? fileName! : label),
                  if (hasFile) TextFormat.bodySecondary("Archivo seleccionado"),
                ],
              ),
            ),
            if (hasFile && onRemove != null)
              IconButton(icon: AppIcon.cancel, onPressed: onRemove),
          ],
        ),
      ],
    );
  }
}
