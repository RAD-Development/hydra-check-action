import * as core from '@actions/core'
import { wait } from './wait'
import axios from 'axios'

/**
 * The main function for the action.
 * @returns {Promise<void>} Resolves when the action is complete.
 */
export async function run(): Promise<void> {
  try {
    const ms = '1000'
    const evaluation_name: string = core.getInput('evaluation-name')
    const hydra_project: string = core.getInput('hydra-project')
    const hydra_url: string = core.getInput('hydra-url')
    const hydra_axios = axios.create({
      baseURL: `${hydra_url}/${hydra_project}`,
      headers: { Accept: 'application/json' }
    })

    // Debug logs are only output if the `ACTIONS_STEP_DEBUG` secret is true
    core.debug(`Waiting ${ms} milliseconds ...`)
    core.debug(`evaluation-name: ${evaluation_name} ...`)
    core.debug(`hydra-url: ${hydra_url} ...`)

    const builds = await hydra_axios.get(`/${evaluation_name}`)

    core.debug(builds.data)
    // Log the current timestamp, wait, then log the new timestamp
    core.debug(new Date().toTimeString())
    await wait(parseInt(ms, 10))
    core.debug(new Date().toTimeString())

    // Set outputs for other workflow steps to use
    core.setOutput('time', new Date().toTimeString())
  } catch (error) {
    // Fail the workflow run if an error occurs
    if (error instanceof Error) core.setFailed(error.message)
  }
}
