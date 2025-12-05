// lib/features/company/models/company_job_item.dart

class CompanyJobItemdata {
  final String? id;
  final String title;
  final String location;
  final String salary;
  final String? thumbnail;
  final String? jobType;
  final String? jobLevel;
  final String? experienceLevel;
  final String? deadline;
  final String? description;

  CompanyJobItemdata({
    this.id,
    required this.title,
    required this.location,
    required this.salary,
    this.thumbnail,
    this.jobType,
    this.jobLevel,
    this.experienceLevel,
    this.deadline,
    this.description,
  });

  // Format job type for display
  String get formattedJobType {
    if (jobType == null) return 'Full Time';
    return jobType!.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  // Check if it's full time
  bool get isFullTime => jobType?.toUpperCase() == 'FULL_TIME';

  // Format deadline date
  String get formattedDeadline {
    if (deadline == null) return '';
    try {
      final date = DateTime.parse(deadline!);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year.toString().substring(2)}';
    } catch (e) {
      return '';
    }
  }
}