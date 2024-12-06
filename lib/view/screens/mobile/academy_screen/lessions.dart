import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/fetch_courses_controller.dart';
import 'package:orca_social_media/models/lesson_model.dart';
import 'package:orca_social_media/view/screens/mobile/academy_screen/video_player_screen.dart';
import 'package:provider/provider.dart';

class LessonScreen extends StatelessWidget {
  final String courseId;
  final String categoryId;

  const LessonScreen({super.key, required this.courseId, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => FetchCoursesController(),
        child: Consumer<FetchCoursesController>(
          builder: (context, fetchCourses, child) {
            return StreamBuilder<List<LessonModel>>(
              stream: fetchCourses.fetchLessons(courseId, categoryId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No lessons available'));
                }

                final lessons = snapshot.data!;

                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return ListTile(
                      leading: const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.video_camera_front),
                      ),
                      title: Text(lesson.lessonName),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoUrl: lesson.lessonVideo,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
