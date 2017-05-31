# Updating select input options

The options for `hours_slept`, `wake_count`, `symptom_scale`, and
`security_questions` can be updated by editing the corresponding `.txt` file.
Go to the file(s) that you want to edit for  
[hours_slept](web/static/assets/hours_slept.txt),
[wake_count](web/static/assets/wake_count.txt),
[security_questions](web/static/assets/security_questions.txt), or
[symptom_scale](web/static/assets/symptom_tracker.txt) and follow
through the instructions below.

Click on the pencil in the top right corner of the file.
![edit-file](https://cloud.githubusercontent.com/assets/1287388/24212494/74f767d0-0f27-11e7-95b8-2b3bff21cbc5.png)

Make any changes you wish to the file. Delete questions, change the wording,
or add new ones. The only thing to keep in mind for this is to put each question
in the file on it's own line. Do not use commas or anything besides a new line
to separate questions.

```
Option 1
Option 2
Option 3
```

After you are done making changes, you can find a box underneath the file that
says `Commit changes`.

![commit-changes](https://cloud.githubusercontent.com/assets/1287388/24213604/fb238f2a-0f2a-11e7-8a60-251e40e3251c.png)

In here, you can write a short message in the box that says `Update` describing
the change e.g. Add new option, Reword security question, etc.

Ensure the bottom option ("*Create a new branch for this commit and start a
pull request.*") is ticked as in the image above.

Click on `Propose file change`.

You will be taken to a new page where you can create a pull request. You can
leave the default text as the title, and reference any related issues in the
comment box.

Click `Create pull request` in the bottom right.

![create-pr](https://cloud.githubusercontent.com/assets/1287388/24213909/e2c6164a-0f2b-11e7-8ccf-d3f206108488.png)

If you are happy with the changes, change the label to `awaiting-review`:

![awaiting-review](https://cloud.githubusercontent.com/assets/1287388/24214001/21fe0ac0-0f2c-11e7-96a5-8f58110637c5.png)

Then add a `Reviewer` and `Assignee` of your choice.
