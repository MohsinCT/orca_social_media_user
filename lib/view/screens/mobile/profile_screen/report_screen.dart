
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/complaints_controller.dart';
import 'package:orca_social_media/models/complaint_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ReportPage extends StatelessWidget {
  final TextEditingController _reportController = TextEditingController();

  void _sendReport(BuildContext context) {
     final userProvider = Provider.of<UserProvider>(context, listen: false);
     String? currentUser = userProvider.getLoggedUserId();

    String report = _reportController.text.trim();
    if (report.isNotEmpty) {
      final complaintController = Provider.of<ComplaintController>(context, listen: false);

      // Create a unique ID for the complaint
      String complaintId = const Uuid().v4(); 

      // Create a complaint model instance
      ComplaintModel newComplaint = ComplaintModel(
        id: complaintId,
        complaint: report,
        replayComplaint: '',
        date: DateTime.now().toIso8601String(),
      );

      // Call the function to add the complaint to Firestore
      complaintController.addComplaint(currentUser!, newComplaint);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report sent successfully!')),
      );

      _reportController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
     String? currentUser = userProvider.getLoggedUserId();
    final mediaQuery = MediaQueryHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _reportController,
                decoration: InputDecoration(
                  hintText: 'Enter your report here',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _sendReport(context),
                child: Text('Send Report'),
              ),
              Column(
                children: [
                  Text(
                    'Complaints',
                    style: TextStyle(
                      fontSize: mediaQuery.screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: mediaQuery.screenWidth,
                    height: mediaQuery.screenHeight * 0.6,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 226, 216, 216),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FutureBuilder<List<ComplaintModel>>(
                      future: Provider.of<ComplaintController>(context).fetchComplaints(currentUser!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading complaints'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No complaints added'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final complaint = snapshot.data![index];
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            complaint.complaint,
                                            style: TextStyle(
                                              fontSize: mediaQuery.screenWidth * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            complaint.date,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Provider.of<ComplaintController>(context, listen: false)
                                              .deleteComplaint(currentUser, complaint.id);
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
