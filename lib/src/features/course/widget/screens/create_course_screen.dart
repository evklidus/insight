import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_colors.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/file/file_widget.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/common/widgets/whole_screen_loading_indicator.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/course/bloc/create_course/create_course_bloc.dart';
import 'package:insight/src/features/course/bloc/create_course/create_course_event.dart';
import 'package:insight/src/features/course/bloc/create_course/create_course_state.dart';
import 'package:permission_handler/permission_handler.dart';

/// {@template create_course_screen}
/// CreateCourseScreen widget.
/// {@endtemplate}
class CreateCourseScreen extends StatefulWidget {
  /// {@macro create_course_screen}
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

/// State for widget CreateCourseScreen.
class _CreateCourseScreenState extends State<CreateCourseScreen> {
  XFile? _image;
  Set<String> _selectedCategory = {};
  bool _isClosed = false;

  final _formKey = GlobalKey<FormState>();

  late final CreateCourseBLoC _createCourseBloc;

  late final TextEditingController _nameController;
  late final TextEditingController _descrController;

  @override
  void initState() {
    super.initState();
    _createCourseBloc = CreateCourseBLoC(
      repository: DIContainer.instance.coursesRepository,
    )..add(const CreateCourseEvent.fetchTags());
    _nameController = TextEditingController();
    _descrController = TextEditingController();
  }

  @override
  void dispose() {
    _createCourseBloc.close();
    _nameController.dispose();
    _descrController.dispose();
    super.dispose();
  }

  Future<void> _addPhotoHandler() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      await Permission.photos.request();
      // TODO: Проверить не зацикливается ли
      _addPhotoHandler();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() => _image = image);
    }
  }

  void _createCourseHandler() {
    if (_image.isNull) {
      return InsightSnackBar.showError(
        context,
        text: AppStrings.addPhotoMessage,
      );
    } else if (_image.isNotNull && _formKey.currentState!.validate()) {
      _createCourseBloc.add(
        CreateCourseEvent.create(
          name: _nameController.text,
          description: _descrController.text,
          imagePath: _image!.path,
          categoryTag: _selectedCategory.first,
          isClosed: _isClosed,
          onCreateCallback: () {
            context.pop();
            InsightSnackBar.showSuccessful(
              context,
              text: AppStrings.courseSuccessfullyCreated,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCourseBLoC, CreateCourseState>(
        listener: (context, state) => state.mapOrNull(
              successful: (state) {
                if (!context.mounted) return;
                if (_selectedCategory.isEmpty && state.hasTags) {
                  setState(
                    () => _selectedCategory = {
                      state.tags!.first.categoryTag,
                    },
                  );
                }
              },
              error: (state) =>
                  InsightSnackBar.showError(context, text: state.message),
            ),
        bloc: _createCourseBloc,
        builder: (context, state) {
          return WholeScreenLoadingIndicator(
            isLoading: state.isProcessing,
            child: AdaptiveScaffold(
              appBar: const CustomAppBar(title: AppStrings.courseCreation),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 103,
                    bottom: 16,
                  ),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        AppStrings.addLessonsAfterCreatingCourse,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const _Headline(AppStrings.photo),
                    const SizedBox(height: 8),
                    FileWidget.editable(
                      filePath: _image?.path,
                      type: FileType.image,
                      onPressed: _addPhotoHandler,
                    ),
                    const SizedBox(height: 16),
                    const _Headline(AppStrings.title),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _nameController,
                      hintText: AppStrings.courseNameHint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const _Headline(AppStrings.description),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _descrController,
                      hintText: AppStrings.courseDescrHint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const _Headline(AppStrings.courseType),
                    const SizedBox(height: 8),
                    Platform.isIOS
                        ? CupertinoSegmentedControl<bool>(
                            selectedColor:
                                context.colorScheme.surfaceContainerHighest,
                            unselectedColor:
                                context.colorScheme.surfaceContainerLow,
                            pressedColor:
                                context.colorScheme.surfaceContainerHigh,
                            borderColor: context.colorScheme.outline
                                .withValues(alpha: 0.25),
                            padding: const EdgeInsets.all(0),
                            groupValue: _isClosed,
                            onValueChanged: (value) =>
                                setState(() => _isClosed = value),
                            children: const {
                              false: _SegmentWidget(AppStrings.courseTypeOpen),
                              true: _SegmentWidget(AppStrings.courseTypeClosed),
                            },
                          )
                        : SegmentedButton<bool>(
                            selected: {_isClosed},
                            segments: const [
                              ButtonSegment(
                                value: false,
                                label: Text(AppStrings.courseTypeOpen),
                              ),
                              ButtonSegment(
                                value: true,
                                label: Text(AppStrings.courseTypeClosed),
                              ),
                            ],
                            onSelectionChanged: (value) =>
                                setState(() => _isClosed = value.first),
                          ),
                    const SizedBox(height: 16),
                    const _Headline(AppStrings.category),
                    const SizedBox(height: 8),
                    // [Visibility] всё равно создаёт child при build родителя — нельзя
                    // использовать state.tags! пока теги не загружены.
                    if (state.tags case final tags?)
                      if (tags.isNotEmpty && _selectedCategory.isNotEmpty)
                        Platform.isIOS
                            ? _CupertinoCategoryPicker(
                                tags: tags,
                                selectedTag: _selectedCategory.first,
                                onTagSelected: (tag) => setState(
                                  () => _selectedCategory = {tag},
                                ),
                              )
                            : _MaterialCategoryDropdown(
                                tags: tags,
                                value: _selectedCategory.first,
                                onChanged: (tag) => setState(
                                  () => _selectedCategory = {tag},
                                ),
                              ),
                    const SizedBox(height: 32),
                    Platform.isIOS
                        ? CupertinoButton.filled(
                            onPressed: _createCourseHandler,
                            child: const Text(AppStrings.create),
                          )
                        : FloatingActionButton.extended(
                            onPressed: _createCourseHandler,
                            label: const Text(AppStrings.create),
                          ),
                    SizedBox(height: MediaQuery.viewPaddingOf(context).bottom),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/// Выпадающий список категорий (Material) — удобен при большом числе тегов.
class _MaterialCategoryDropdown extends StatelessWidget {
  const _MaterialCategoryDropdown({
    required this.tags,
    required this.value,
    required this.onChanged,
  });

  final List<({String categoryName, String categoryTag})> tags;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Material(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(12),
            items: tags
                .map(
                  (t) => DropdownMenuItem<String>(
                    value: t.categoryTag,
                    child: Text(
                      t.categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (tag) {
              if (tag != null) onChanged(tag);
            },
          ),
        ),
      );
}

/// Поле + bottom sheet со списком (Cupertino) — без колеса, удобнее при многих пунктах.
class _CupertinoCategoryPicker extends StatelessWidget {
  const _CupertinoCategoryPicker({
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  final List<({String categoryName, String categoryTag})> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  String get _displayTitle {
    for (final t in tags) {
      if (t.categoryTag == selectedTag) return t.categoryName;
    }
    return selectedTag;
  }

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: _displayTitle,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: () => _openPicker(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _displayTitle,
                      style: context.textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 18,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _openPicker(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: scheme.scrim.withValues(alpha: 0.5),
      useRootNavigator: true,
      builder: (ctx) {
        final s = Theme.of(ctx).colorScheme;
        final t = Theme.of(ctx);
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: s.surface.withValues(alpha: 0.94),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(
                      color: s.outlineVariant.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: s.onSurface.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const SizedBox(width: 40, height: 4),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppStrings.category,
                              style: t.textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: s.onSurface,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text(
                              AppStrings.done,
                              style: TextStyle(
                                inherit: false,
                                color: AppColors.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: tags.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final tag = tags[index];
                            final selected = tag.categoryTag == selectedTag;
                            return _CategorySheetItem(
                              title: tag.categoryName,
                              selected: selected,
                              colorScheme: s,
                              textTheme: t.textTheme,
                              onTap: () {
                                onTagSelected(tag.categoryTag);
                                Navigator.of(ctx).pop();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Строка категории в bottom sheet: iOS — затемнение при нажатии (Cupertino),
/// Android — Material splash.
class _CategorySheetItem extends StatelessWidget {
  const _CategorySheetItem({
    required this.title,
    required this.selected,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? colorScheme.surfaceContainerHighest : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                ),
              ),
            ),
            if (selected)
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );

    if (Platform.isIOS) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          pressedOpacity: 0.55,
          onPressed: onTap,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

class _SegmentWidget extends StatelessWidget {
  const _SegmentWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: context.textTheme.labelLarge,
        ),
      );
}

class _Headline extends StatelessWidget {
  const _Headline(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: context.textTheme.titleLarge,
      );
}
