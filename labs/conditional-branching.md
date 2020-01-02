# Conditional branching

![alt](../img/conditional-pipeline.png)
This will intro
TODO: add all

## when


## PR based

```
        stage('change request') {
          when { changeRequest() }
          steps {
            sh 'echo "this is a change request"'
          }
        }
```