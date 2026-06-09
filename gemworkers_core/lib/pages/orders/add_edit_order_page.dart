import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/customer.dart';
import '../../models/inventory_item.dart';
import '../../models/order.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/order_repository.dart';
import '../../shared/form_widgets.dart';

class AddEditOrderPage extends StatefulWidget {
  final Order? order;
  const AddEditOrderPage({super.key, this.order});

  @override
  State<AddEditOrderPage> createState() => _AddEditOrderPageState();
}

class _AddEditOrderPageState extends State<AddEditOrderPage> {
  final _orderRepo = OrderRepository();
  final _customerRepo = CustomerRepository();

  List<Customer> _customers = [];
  bool _loadingCustomers = true;
  bool _saving = false;

  String? _customerId;
  String _status = 'draft';
  DateTime _orderDate = DateTime.now();
  final _notes = TextEditingController();

  // Line items being built.
  final List<_DraftItem> _items = [];

  bool get _isEdit => widget.order != null;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    final o = widget.order;
    if (o != null) {
      _customerId = o.customerId;
      _status = o.status;
      _orderDate = o.orderDate;
      _notes.text = o.notes;
      _items.addAll(o.items.map((i) => _DraftItem.fromOrderItem(i)));
    }
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _customerRepo.getCustomers();
      if (mounted) {
        setState(() {
          _customers = customers;
          _loadingCustomers = false;
          // Select first if adding and none set.
          if (_customerId == null && customers.isNotEmpty) {
            _customerId = customers.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingCustomers = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _orderDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _orderDate = picked);
  }

  Future<void> _openItemPicker() async {
    final picked = await showDialog<_DraftItem>(
      context: context,
      builder: (_) => _ItemPickerDialog(
        alreadyPicked: _items.map((i) => i.inventoryItemId).toSet(),
      ),
    );
    if (picked != null) setState(() => _items.add(picked));
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  double get _total =>
      _items.fold(0.0, (sum, i) => sum + i.price * i.quantity);

  Future<void> _save() async {
    if (_customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a customer')));
      return;
    }

    setState(() => _saving = true);
    try {
      if (_isEdit) {
        final updated = widget.order!.copyWith(
          customerId: _customerId,
          status: _status,
          orderDate: _orderDate,
          notes: _notes.text.trim(),
        );
        await _orderRepo.updateOrder(widget.order!.id!, updated);
        await _orderRepo.replaceOrderItems(
          widget.order!.id!,
          _items.map((i) => i.toOrderItem()).toList(),
        );
      } else {
        final order = Order(
          customerId: _customerId,
          status: _status,
          orderDate: _orderDate,
          notes: _notes.text.trim(),
        );
        final created = await _orderRepo.addOrder(order);
        await _orderRepo.addOrderItems(
          created.id!,
          _items.map((i) => i.toOrderItem()).toList(),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Order' : 'New Order'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: _loadingCustomers
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormSection('Order Details'),
                  if (_customers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'No customers found. Add a customer first.',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  else
                    FormDropdownField<String?>(
                      label: 'Customer',
                      value: _customerId,
                      items: _customers.map((c) => c.id).toList(),
                      onChanged: (v) => setState(() => _customerId = v),
                      itemLabel: (id) =>
                          _customers
                              .where((c) => c.id == id)
                              .firstOrNull
                              ?.name ??
                          id ??
                          '',
                    ),
                  FormDropdownField<String>(
                    label: 'Status',
                    value: _status,
                    items: const ['draft', 'confirmed'],
                    onChanged: (v) => setState(() => _status = v ?? 'draft'),
                    itemLabel: (v) => v == 'confirmed' ? 'Confirmed' : 'Draft',
                  ),
                  _DatePickerRow(date: _orderDate, onTap: _pickDate),
                  FormTextField('Notes', _notes, maxLines: 2),
                  const FormSection('Line Items'),
                  if (_items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'No items added yet',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    )
                  else
                    ..._items.asMap().entries.map((e) => _LineItemRow(
                          item: e.value,
                          onRemove: () => _removeItem(e.key),
                          onQuantityChanged: (qty) {
                            setState(() => _items[e.key] =
                                _items[e.key].copyWith(quantity: qty));
                          },
                          onPriceChanged: (price) {
                            setState(() => _items[e.key] =
                                _items[e.key].copyWith(price: price));
                          },
                        )),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _openItemPicker,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                  const SizedBox(height: 16),
                  if (_items.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          Text(
                            '€${_total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// ── Draft item model ──────────────────────────────────────────────────────────

class _DraftItem {
  final String? orderItemId;
  final String inventoryItemId;
  final String title;
  final String sku;
  final double price;
  final int quantity;

  const _DraftItem({
    this.orderItemId,
    required this.inventoryItemId,
    required this.title,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  factory _DraftItem.fromOrderItem(OrderItem item) => _DraftItem(
        orderItemId: item.id,
        inventoryItemId: item.inventoryItemId,
        title: item.itemTitle,
        sku: item.itemSku,
        price: item.priceAtSale,
        quantity: item.quantity,
      );

  factory _DraftItem.fromInventory(InventoryItem item) => _DraftItem(
        inventoryItemId: item.id!,
        title: item.title,
        sku: item.sku,
        price: item.salePrice,
        quantity: 1,
      );

  OrderItem toOrderItem() => OrderItem(
        id: orderItemId,
        inventoryItemId: inventoryItemId,
        itemTitle: title,
        itemSku: sku,
        priceAtSale: price,
        quantity: quantity,
      );

  _DraftItem copyWith({double? price, int? quantity}) => _DraftItem(
        orderItemId: orderItemId,
        inventoryItemId: inventoryItemId,
        title: title,
        sku: sku,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
      );
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _DatePickerRow extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  const _DatePickerRow({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Order Date',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
          ),
          child: Text(
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}',
          ),
        ),
      ),
    );
  }
}

class _LineItemRow extends StatefulWidget {
  final _DraftItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<double> onPriceChanged;

  const _LineItemRow({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.onPriceChanged,
  });

  @override
  State<_LineItemRow> createState() => _LineItemRowState();
}

class _LineItemRowState extends State<_LineItemRow> {
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    _price =
        TextEditingController(text: widget.item.price.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (widget.item.sku.isNotEmpty)
                        Text(widget.item.sku,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onRemove,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Quantity stepper
                Row(
                  children: [
                    const Text('Qty: ',
                        style: TextStyle(fontSize: 13)),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.item.quantity > 1
                          ? () => widget.onQuantityChanged(
                              widget.item.quantity - 1)
                          : null,
                    ),
                    Text(
                      '${widget.item.quantity}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => widget
                          .onQuantityChanged(widget.item.quantity + 1),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Price field
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _price,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Price (€)',
                        isDense: true,
                        prefixText: '€ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) {
                        final parsed = double.tryParse(v);
                        if (parsed != null) widget.onPriceChanged(parsed);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Subtotal
                Text(
                  '€${(widget.item.price * widget.item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Item picker dialog ────────────────────────────────────────────────────────

class _ItemPickerDialog extends StatefulWidget {
  final Set<String> alreadyPicked;
  const _ItemPickerDialog({required this.alreadyPicked});

  @override
  State<_ItemPickerDialog> createState() => _ItemPickerDialogState();
}

class _ItemPickerDialogState extends State<_ItemPickerDialog> {
  final _repo = InventoryRepository();
  final _search = TextEditingController();

  List<InventoryItem> _all = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _search.addListener(() =>
        setState(() => _query = _search.text.toLowerCase().trim()));
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final items = await _repo.getItems();
      if (mounted) {
        setState(() {
          _all = items
              .where((i) =>
                  i.status == 'available' &&
                  !widget.alreadyPicked.contains(i.id))
              .toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<InventoryItem> get _filtered {
    if (_query.isEmpty) return _all;
    return _all
        .where((i) =>
            i.title.toLowerCase().contains(_query) ||
            i.sku.toLowerCase().contains(_query) ||
            i.gemType.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 580),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pick an Item',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search title, SKU, gem type…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: _search.clear,
                        )
                      : null,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(
                          child: Text('No available items',
                              style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final item = filtered[i];
                            return ListTile(
                              dense: true,
                              onTap: () => Navigator.pop(
                                context,
                                _DraftItem.fromInventory(item),
                              ),
                              title: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                item.sku.isNotEmpty
                                    ? '${item.sku} · ${item.gemType}'
                                    : item.gemType,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                '€${item.salePrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
