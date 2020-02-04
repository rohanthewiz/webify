import 'package:flutter/material.dart';

class CustomDataTable<T> extends StatefulWidget {
  final T fixedCornerCell;
  final List<T> fixedColumn;
  final List<T> fixedRow;
  final List<List<T>> dataRows;
  final Widget Function(T data) cellBuilder;
  final double fixedColWidth;
  final double cellWidth;
  final double cellHeight;
  final double cellMargin;
  final double cellSpacing;

  CustomDataTable({
    this.fixedCornerCell,
    this.fixedColumn,
    this.fixedRow,
    @required this.dataRows,
    this.cellBuilder,
    this.fixedColWidth = 60.0,
    this.cellHeight = 56.0,
    this.cellWidth = 120.0,
    this.cellMargin = 10.0,
    this.cellSpacing = 10.0,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState<T> extends State<CustomDataTable<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();

  Widget _buildChild(double width, T data) => SizedBox(
      width: width, child: widget.cellBuilder?.call(data) ?? Text('$data'));

  Widget _buildFixedCol() => widget.fixedColumn == null
      ? SizedBox.shrink()
      : Material(
          color: Colors.lightBlueAccent,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              dataRowHeight: widget.cellHeight,
              columns: [
                DataColumn(
                    label: _buildChild(
                        widget.fixedColWidth, widget.fixedColumn.first))
              ],
              rows: widget.fixedColumn
                  .sublist(widget.fixedRow == null ? 1 : 0)
                  .map((c) => DataRow(
                      cells: [DataCell(_buildChild(widget.fixedColWidth, c))]))
                  .toList()),
        );

  Widget _buildFixedRow() => widget.fixedRow == null
      ? SizedBox.shrink()
      : Material(
          color: Colors.grey,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              dataRowHeight: widget.cellHeight,
              columns: widget.fixedRow
                  .map((c) =>
                      DataColumn(label: _buildChild(widget.cellWidth, c)))
                  .toList(),
              rows: []),
        );

  Widget _buildSubTable() => Material(
      color: Colors.lightGreenAccent,
      child: DataTable(
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: widget.cellHeight,
          dataRowHeight: widget.cellHeight,
          columns: widget.dataRows.first
              .map((c) => DataColumn(label: _buildChild(widget.cellWidth, c)))
              .toList(),
          rows: widget.dataRows
              .sublist(widget.fixedRow == null ? 1 : 0)
              .map((row) => DataRow(
                  cells: row
                      .map((c) => DataCell(_buildChild(widget.cellWidth, c)))
                      .toList()))
              .toList()));

  Widget _buildCornerCell() =>
      widget.fixedColumn == null || widget.fixedRow == null
          ? SizedBox.shrink()
          : Material(
              color: Colors.grey,
              child: DataTable(
                  horizontalMargin: widget.cellMargin,
                  columnSpacing: widget.cellSpacing,
                  headingRowHeight: widget.cellHeight,
                  dataRowHeight: widget.cellHeight,
                  columns: [
                    DataColumn(
                        label: _buildChild(
                            widget.fixedColWidth, widget.fixedCornerCell))
                  ],
                  rows: []),
            );

  @override
  void initState() {
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            SingleChildScrollView(
              controller: _columnController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              child: _buildFixedCol(),
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: _subTableXController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _subTableYController,
                  scrollDirection: Axis.vertical,
                  child: _buildSubTable(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildCornerCell(),
            Flexible(
              child: SingleChildScrollView(
                controller: _rowController,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: _buildFixedRow(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
