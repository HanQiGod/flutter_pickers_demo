import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/locations_data.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'flutter_pickers Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF3F7F6),
        textTheme: Typography.material2021().black.apply(
          bodyColor: const Color(0xFF0F172A),
          displayColor: const Color(0xFF0F172A),
        ),
      ),
      home: const PickerDemoPage(),
    );
  }
}

class PickerDemoPage extends StatefulWidget {
  const PickerDemoPage({super.key});

  @override
  State<PickerDemoPage> createState() => _PickerDemoPageState();
}

class _PickerDemoPageState extends State<PickerDemoPage> {
  static const Map<String, dynamic> _productData = {
    '数码产品': {
      '手机': ['华为', '小米', '苹果', '三星'],
      '电脑': ['笔记本', '台式机', '平板'],
      '配件': ['充电器', '耳机', '贴膜'],
    },
    '家用电器': {
      '大家电': ['冰箱', '洗衣机', '电视'],
      '厨房电器': ['电饭煲', '微波炉', '烤箱'],
      '生活电器': ['风扇', '吸尘器', '加湿器'],
    },
    '图书音像': {
      '文学': ['小说', '散文', '诗歌'],
      '科技': ['编程', 'AI', '硬件'],
    },
  };

  final List<List<String>> _timeColumns = [
    const ['上午', '下午'],
    List.generate(12, (index) => (index + 1).toString()),
    List.generate(60, (index) => index.toString().padLeft(2, '0')),
    List.generate(60, (index) => index.toString().padLeft(2, '0')),
  ];

  String _province = '四川省';
  String _city = '成都市';
  String _town = '双流区';

  String _provinceOnly = '四川省';
  String _cityOnly = '成都市';

  String _skill = 'Dart';
  String _education = '本科';
  List<String> _multipleSelection = ['上午', '10', '30', '15'];
  List<String> _linkSelection = ['数码产品', '手机', '华为'];
  PDuration _selectedDate = PDuration(
    year: 2024,
    month: 1,
    day: 1,
    hour: 9,
    minute: 30,
    second: 15,
  );

  List<String> _cityCodes = const [];
  List<String> _cityNames = const [];
  String _status = '点击下方按钮，逐项体验 flutter_pickers 的能力。';

  @override
  void initState() {
    super.initState();
    _cityCodes = Address.getCityCodeByName(
      provinceName: _province,
      cityName: _city,
      townName: _town,
    );
    _cityNames = Address.getCityNameByCode(
      provinceCode: '510000',
      cityCode: '510100',
      townCode: '510104',
    );
  }

  void _showAddressPicker() {
    Pickers.showAddressPicker(
      context,
      initProvince: _province,
      initCity: _city,
      initTown: _town,
      pickerStyle: DefaultPickerStyle(title: '省市区三级联动'),
      onConfirm: (province, city, town) {
        setState(() {
          _province = province;
          _city = city;
          _town = town ?? '';
          _cityCodes = Address.getCityCodeByName(
            provinceName: _province,
            cityName: _city,
            townName: _town,
          );
          _status = '地址选择完成：$_province - $_city - $_town';
        });
      },
    );
  }

  void _showCityPicker() {
    Pickers.showAddressPicker(
      context,
      initProvince: _provinceOnly,
      initCity: _cityOnly,
      initTown: null,
      pickerStyle: ClosePickerStyle(haveRadius: true, title: '只选择到市'),
      onConfirm: (province, city, town) {
        setState(() {
          _provinceOnly = province;
          _cityOnly = city;
          _status = '二级地址选择完成：$_provinceOnly - $_cityOnly';
        });
      },
    );
  }

  void _showStyledAddressPicker() {
    Pickers.showAddressPicker(
      context,
      initProvince: _province,
      initCity: _city,
      initTown: _town,
      addAllItem: false,
      pickerStyle: PickerStyle(
        showTitleBar: true,
        title: const Center(
          child: Text(
            '自定义地址样式',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        cancelButton: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Text(
              '取消',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
            ),
          ),
        ),
        commitButton: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            '确定',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        headDecoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        backgroundColor: const Color(0xFF111827),
        textColor: Colors.white,
        pickerItemHeight: 46,
        itemOverlay: IgnorePointer(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFF38BDF8), width: 1.2),
                  ),
                ),
                child: SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
      onConfirm: (province, city, town) {
        setState(() {
          _province = province;
          _city = city;
          _town = town ?? '';
          _cityCodes = Address.getCityCodeByName(
            provinceName: _province,
            cityName: _city,
            townName: _town,
          );
          _status = '暗色自定义样式选择完成：$_province - $_city - $_town';
        });
      },
    );
  }

  void _showSkillPicker() {
    Pickers.showSinglePicker(
      context,
      data: ['PHP', 'JAVA', 'C++', 'Dart', 'Python', 'Go'],
      selectData: _skill,
      suffix: ' 技术栈',
      pickerStyle: RaisedPickerStyle(
        title: '单项选择器',
        color: const Color(0xFF0F766E),
      ),
      onConfirm: (data, position) {
        setState(() {
          _skill = data.toString();
          _status = '单项选择器已更新：$_skill';
        });
      },
    );
  }

  void _showEducationPicker() {
    Pickers.showSinglePicker(
      context,
      data: PickerDataType.education,
      selectData: _education,
      pickerStyle: DefaultPickerStyle.dark(title: '内置预设数据'),
      onConfirm: (data, position) {
        setState(() {
          _education = data.toString();
          _status = '内置学历预设已更新：$_education';
        });
      },
    );
  }

  void _showMultiPicker() {
    Pickers.showMultiPicker(
      context,
      data: _timeColumns,
      selectData: _multipleSelection,
      suffix: const ['', '时', '分', '秒'],
      pickerStyle: NoTitleStyle.dark(),
      onConfirm: (res, position) {
        setState(() {
          _multipleSelection = List<String>.from(
            res.map((item) => item.toString()),
          );
          _status = '多项选择器已更新：${_multipleSelection.join(' ')}';
        });
      },
    );
  }

  void _showMultiLinkPicker() {
    Pickers.showMultiLinkPicker(
      context,
      data: _productData,
      columnNum: 3,
      selectData: _linkSelection,
      suffix: const ['', '', ''],
      pickerStyle: ClosePickerStyle.dark(haveRadius: true, title: '自定义联动选择器'),
      onConfirm: (res, position) {
        setState(() {
          _linkSelection = List<String>.from(
            res.map((item) => item.toString()),
          );
          _status = '联动选择器已更新：${_linkSelection.join(' - ')}';
        });
      },
    );
  }

  void _showDatePicker() {
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMDHMS,
      selectDate: _copyDuration(_selectedDate),
      minDate: PDuration(year: 2020),
      maxDate: PDuration(
        year: 2030,
        month: 12,
        day: 31,
        hour: 23,
        minute: 59,
        second: 59,
      ),
      suffix: Suffix(
        years: '年',
        month: '月',
        days: '日',
        hours: '时',
        minutes: '分',
        seconds: '秒',
      ),
      pickerStyle: DefaultPickerStyle(title: '时间选择器'),
      onConfirm: (value) {
        setState(() {
          _selectedDate = _copyDuration(value);
          _status = '时间选择器已更新：${_formatDuration(_selectedDate)}';
        });
      },
    );
  }

  void _queryCodeByName() {
    final codes = Address.getCityCodeByName(
      provinceName: _province,
      cityName: _city,
      townName: _town,
    );
    setState(() {
      _cityCodes = codes;
      _status = '根据名称查询城市码完成：${codes.join(' / ')}';
    });
  }

  void _queryNameByCode() {
    final names = Address.getCityNameByCode(
      provinceCode: '510000',
      cityCode: '510100',
      townCode: '510104',
    );
    setState(() {
      _cityNames = names;
      _status = '根据编码查询城市名完成：${names.join(' / ')}';
    });
  }

  PDuration _copyDuration(PDuration value) {
    return PDuration(
      year: value.year ?? 0,
      month: value.month ?? 0,
      day: value.day ?? 0,
      hour: value.hour ?? 0,
      minute: value.minute ?? 0,
      second: value.second ?? 0,
    );
  }

  String _formatDuration(PDuration value) {
    final year = (value.year ?? 0).toString().padLeft(4, '0');
    final month = (value.month ?? 0).toString().padLeft(2, '0');
    final day = (value.day ?? 0).toString().padLeft(2, '0');
    final hour = (value.hour ?? 0).toString().padLeft(2, '0');
    final minute = (value.minute ?? 0).toString().padLeft(2, '0');
    final second = (value.second ?? 0).toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  String _formatList(List<String> values) {
    if (values.isEmpty) {
      return '暂无结果';
    }
    return values.join(' / ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F7F3), Color(0xFFF7FBFA)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F766E), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x220F766E),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'flutter_pickers Demo',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '内置省市区数据，开箱即用的全能选择器库。',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _FeatureBadge(label: '地址联动'),
                        _FeatureBadge(label: '单项 / 多项'),
                        _FeatureBadge(label: '16 种时间模式'),
                        _FeatureBadge(label: '城市码查询'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        _status,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _DemoCard(
                title: '地址选择器',
                subtitle: '覆盖文章里的三级联动、二级联动和样式定制场景。',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionChipButton(
                          icon: Icons.map_outlined,
                          label: '省市区三级联动',
                          onPressed: _showAddressPicker,
                        ),
                        _ActionChipButton(
                          icon: Icons.location_city_outlined,
                          label: '只选省市',
                          onPressed: _showCityPicker,
                        ),
                        _ActionChipButton(
                          icon: Icons.palette_outlined,
                          label: '自定义暗色样式',
                          onPressed: _showStyledAddressPicker,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(
                      label: '当前省市区',
                      value: '$_province - $_city - $_town',
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      label: '当前省市',
                      value: '$_provinceOnly - $_cityOnly',
                    ),
                    const SizedBox(height: 12),
                    const _InfoTile(
                      label: '已使用样式',
                      value:
                          'DefaultPickerStyle / ClosePickerStyle / PickerStyle',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _DemoCard(
                title: '城市码查询工具',
                subtitle: '根据名称查编码，也能根据编码反查城市名。',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionChipButton(
                          icon: Icons.pin_drop_outlined,
                          label: '名称查城市码',
                          onPressed: _queryCodeByName,
                        ),
                        _ActionChipButton(
                          icon: Icons.tag_outlined,
                          label: '编码查城市名',
                          onPressed: _queryNameByCode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(
                      label: '$_province / $_city / $_town',
                      value: _formatList(_cityCodes),
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      label: '510000 / 510100 / 510104',
                      value: _formatList(_cityNames),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _DemoCard(
                title: '单项选择与内置预设',
                subtitle: '同时展示通用单选和内置数据源的开箱即用能力。',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionChipButton(
                          icon: Icons.code_outlined,
                          label: '选择技术栈',
                          onPressed: _showSkillPicker,
                        ),
                        _ActionChipButton(
                          icon: Icons.school_outlined,
                          label: '选择学历',
                          onPressed: _showEducationPicker,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(label: '技术栈结果', value: _skill),
                    const SizedBox(height: 12),
                    _InfoTile(label: '学历结果', value: _education),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _MiniTag(label: 'sex'),
                        _MiniTag(label: 'education'),
                        _MiniTag(label: 'subject'),
                        _MiniTag(label: 'constellation'),
                        _MiniTag(label: 'zodiac'),
                        _MiniTag(label: 'ethnicity'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _DemoCard(
                title: '多项选择与联动',
                subtitle: '适合时分秒、多列独立数据以及 Map 嵌套联动数据。',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionChipButton(
                          icon: Icons.schedule_outlined,
                          label: '多项时间选择',
                          onPressed: _showMultiPicker,
                        ),
                        _ActionChipButton(
                          icon: Icons.account_tree_outlined,
                          label: '商品分类联动',
                          onPressed: _showMultiLinkPicker,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(
                      label: '多项选择结果',
                      value:
                          '${_multipleSelection[0]} ${_multipleSelection[1]}时'
                          '${_multipleSelection[2]}分${_multipleSelection[3]}秒',
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      label: '联动选择结果',
                      value: _linkSelection.join(' - '),
                    ),
                    const SizedBox(height: 12),
                    const _InfoTile(
                      label: '联动数据结构',
                      value: 'Map -> Map -> List，和文章里的商品分类示例一致。',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _DemoCard(
                title: '时间选择器',
                subtitle: '当前示例使用 YMDHMS 模式，支持最小和最大时间限制。',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActionChipButton(
                      icon: Icons.event_outlined,
                      label: '打开时间选择器',
                      onPressed: _showDatePicker,
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(
                      label: '当前时间结果',
                      value: _formatDuration(_selectedDate),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _MiniTag(label: 'YMDHMS'),
                        _MiniTag(label: 'YMDHM'),
                        _MiniTag(label: 'YMD'),
                        _MiniTag(label: 'YM'),
                        _MiniTag(label: 'MD'),
                        _MiniTag(label: 'HM'),
                        _MiniTag(label: 'HMS'),
                        _MiniTag(label: '共 16 种模式'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF0F766E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFDBF2EA),
        foregroundColor: const Color(0xFF0F766E),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0F766E),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
