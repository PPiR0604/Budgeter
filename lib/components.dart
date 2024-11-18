import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.onSaved,
    this.onTap,
    this.keyboardType,
    this.enableInteractiveSelection,
    this.readOnly,
  });

  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? enableInteractiveSelection;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          textAlign: TextAlign.left,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: 4),
        TextFormField(
          keyboardType: keyboardType,
          readOnly: readOnly ?? false,
          enableInteractiveSelection: enableInteractiveSelection,
          controller: controller,
          validator: validator,
          onSaved: onSaved,
          onTap: onTap,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomInputDatePickerFormField extends StatefulWidget {
  const CustomInputDatePickerFormField({
    super.key,
    required this.labelText,
    this.onSaved,
    this.validator,
  });

  final FormFieldSetter<DateTime>? onSaved;
  final FormFieldValidator<String>? validator;
  final String labelText;

  @override
  State<CustomInputDatePickerFormField> createState() =>
      _CustomInputDatePickerFormFieldState();
}

class _CustomInputDatePickerFormFieldState
    extends State<CustomInputDatePickerFormField> {
  final controller = TextEditingController();
  var selectedDate = DateTime.now();

  @override
  void initState() {
    controller.text =
        '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          textAlign: TextAlign.left,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: 4),
        CustomTextFormField(
          labelText: 'T',
          onTap: () async {
            final newDate = await showDatePicker(
                  context: context,
                  currentDate: DateTime.now(),
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  lastDate: DateTime.now(),
                ) ??
                selectedDate;
            setState(() {
              selectedDate = newDate;
            });
          },
        ),
      ],
    );
  }
}

class CustomInputTimePickerFormField extends StatefulWidget {
  const CustomInputTimePickerFormField({
    super.key,
    required this.labelText,
    this.onSaved,
  });

  final String labelText;
  final FormFieldSetter? onSaved;

  @override
  State<CustomInputTimePickerFormField> createState() =>
      _CustomInputTimePickerFormFieldState();
}

class _CustomInputTimePickerFormFieldState
    extends State<CustomInputTimePickerFormField> {
  final controller = TextEditingController();
  var selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    controller.text = '${selectedTime.hour}:${selectedTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          textAlign: TextAlign.left,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: 4),
        TextFormField(
          readOnly: true,
          controller: controller,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
          ),
          onSaved: (string) {
            final callBack = widget.onSaved;
            if (callBack == null) return;
            callBack(selectedTime);
          },
          onTap: () async {
            final newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ) ??
                selectedTime;
            setState(() {
              selectedTime = newTime;
            });
          },
        ),
      ],
    );
  }
}

class CustomDateTimeFormFields extends StatefulWidget {
  CustomDateTimeFormFields({
    super.key,
    this.onSaved,
    this.firstDate,
    this.lastDate,
  });

  final FormFieldSetter<DateTime>? onSaved;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<CustomDateTimeFormFields> createState() =>
      _CustomDateTimeFormFieldsState();
}

class _CustomDateTimeFormFieldsState extends State<CustomDateTimeFormFields> {
  late DateTime selectedDate;
  final dateFieldController = TextEditingController();
  final timeFieldController = TextEditingController();

  void _updateControllerDateText(DateTime date) {
    dateFieldController.text = '${date.year}/${date.month}/${date.day}';
    timeFieldController.text = '${date.hour}:${date.minute}';
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    _updateControllerDateText(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // date field
        Expanded(
          child: CustomTextFormField(
            enableInteractiveSelection: false,
            readOnly: true,
            labelText: 'Tanggal',
            controller: dateFieldController,
            onSaved: (value) {
              final callback = widget.onSaved;
              if (callback == null) return;
              callback(selectedDate);
            },
            onTap: () async {
              final newDate = await showDatePicker(
                    context: context,
                    currentDate: DateTime.now(),
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                    lastDate: DateTime.now(),
                  ) ??
                  selectedDate;
              setState(() {
                selectedDate = DateTime(
                  newDate.year,
                  newDate.month,
                  newDate.day,
                  selectedDate.hour,
                  selectedDate.minute,
                );

                _updateControllerDateText(selectedDate);
              });
            },
          ),
        ),
        SizedBox(width: 8),
        // time field
        Expanded(
          child: CustomTextFormField(
            labelText: 'Waktu',
            enableInteractiveSelection: false,
            readOnly: true,
            controller: timeFieldController,
            onTap: () async {
              final newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ) ??
                  TimeOfDay(
                      hour: selectedDate.hour, minute: selectedDate.minute);

              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  newTime.hour,
                  newTime.minute,
                );

                _updateControllerDateText(selectedDate);
              });
            },
          ),
        )
      ],
    );
  }
}
